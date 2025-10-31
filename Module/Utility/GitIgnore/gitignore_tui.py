#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - GitIgnore TUI Plugin
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       TUI (Text User Interface) for GitIgnore template generator.
#       Left panel: Available templates, Bottom: Selected items, Right: Generated content
#
# Created: 2025-10-31
# Updated: 2025-10-31
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

"""
GitIgnore Template Generator TUI

A Terminal User Interface for generating .gitignore templates using the gitignore.io API.
Features a four-panel layout: search, templates list, selected items, and generated content.

Usage:
```bash
python gitignore_tui.py
```

Controls:
- Arrow keys: Navigate template list and selected items
- Space/Enter: Select/deselect template (Templates panel), Remove template (Selected panel)
- Tab: Switch between panels
- s: Save generated .gitignore file
- r: Refresh templates list
- c: Clear all selections
- i: Show app information
- q/Esc: Quit application
"""

import curses
import json
import sys
import threading
import time
from pathlib import Path
from typing import List, Optional, Set, Tuple
import urllib.error
import urllib.request


def fuzzy_search(query: str, text: str) -> Tuple[bool, int]:
    """
    Fuzzy search algorithm that finds if query characters appear in order in text.
    Returns (match_found, score) where higher score is better match.
    """
    if not query:
        return True, 0

    query = query.lower()
    text = text.lower()

    if query in text:
        return True, 1000 - text.index(query)

    query_idx = 0
    score = 0

    for i, char in enumerate(text):
        if query_idx < len(query) and char == query[query_idx]:
            score += 100 - i
            query_idx += 1

    if query_idx == len(query):
        return True, score

    return False, 0


class GitIgnoreAPI:
    """Client for gitignore.io API with robust error handling"""

    BASE_URL = "https://www.toptal.com/developers/gitignore/api"
    TIMEOUT = 10
    USER_AGENT = "GitIgnore-TUI/4.1.0"

    @classmethod
    def _fetch_url(cls, url: str) -> str:
        """Fetch content from URL with proper error handling"""
        try:
            req = urllib.request.Request(url, headers={"User-Agent": cls.USER_AGENT})
            with urllib.request.urlopen(req, timeout=cls.TIMEOUT) as response:
                return response.read().decode("utf-8")
        except urllib.error.URLError as e:
            raise RuntimeError(f"Network error: {e}")
        except Exception as e:
            raise RuntimeError(f"Unexpected error: {e}")

    @classmethod
    def get_templates(cls, technologies: List[str]) -> str:
        """Get gitignore content for specified technologies"""
        if not technologies:
            return "# No templates selected\n# Select templates from the Available Templates panel"

        clean_techs = []
        for tech in technologies:
            clean_tech = str(tech).strip()
            clean_tech = ''.join(c for c in clean_tech if c.isalnum() or c in '-_.')
            if clean_tech:
                clean_techs.append(clean_tech)

        if not clean_techs:
            return "# No valid templates provided"

        tech_string = ",".join(clean_techs).lower()
        url = f"{cls.BASE_URL}/{tech_string}"

        return cls._fetch_url(url)

    @classmethod
    def list_templates(cls) -> List[str]:
        """Get list of available templates"""
        url = f"{cls.BASE_URL}/list"
        response = cls._fetch_url(url)

        all_templates = []
        for line in response.strip().split('\n'):
            for template in line.split(','):
                clean_template = template.strip()
                if clean_template and clean_template.replace('-', '').replace('_', '').isalnum():
                    all_templates.append(clean_template)

        return sorted(set(all_templates))


class Theme:
    """Color theme configuration for the TUI"""

    NORMAL = 1
    SELECTED = 2
    BORDER = 3
    TITLE = 4
    STATUS = 5
    ERROR = 6
    SUCCESS = 7
    HIGHLIGHT = 8

    @classmethod
    def init_colors(cls):
        """Initialize color pairs for the terminal"""
        if not curses.has_colors():
            return

        curses.start_color()
        curses.use_default_colors()

        try:
            curses.init_pair(cls.NORMAL, curses.COLOR_WHITE, -1)
            curses.init_pair(cls.SELECTED, curses.COLOR_BLACK, curses.COLOR_CYAN)
            curses.init_pair(cls.BORDER, curses.COLOR_BLUE, -1)
            curses.init_pair(cls.TITLE, curses.COLOR_YELLOW, -1)
            curses.init_pair(cls.STATUS, curses.COLOR_GREEN, -1)
            curses.init_pair(cls.ERROR, curses.COLOR_RED, -1)
            curses.init_pair(cls.SUCCESS, curses.COLOR_GREEN, -1)
            curses.init_pair(cls.HIGHLIGHT, curses.COLOR_MAGENTA, -1)
        except curses.error:
            pass

    @classmethod
    def get_color(cls, color_pair: int) -> int:
        """Get color pair with fallback to normal if not available"""
        try:
            return curses.color_pair(color_pair)
        except curses.error:
            return curses.color_pair(cls.NORMAL) if cls.NORMAL != color_pair else curses.A_NORMAL


class GitIgnoreTUI:
    """Main TUI application class"""

    def __init__(self, stdscr):
        """Initialize the TUI application"""
        self.stdscr = stdscr
        self.running = True
        self.status_message = "Loading templates..."
        self.error_message = ""
        self.message_timestamp = time.time()

        # Data
        self.templates: List[str] = []
        self.selected_templates: Set[str] = set()
        self.generated_content = ""
        self.filter_text = ""
        self.filtered_templates: List[str] = []

        # Usage tracking
        self.template_usage: dict = {}
        self.recently_used: List[str] = []
        self._load_usage_data()

        # UI state
        self.current_panel = 1
        self.template_scroll = 0
        self.template_selected = 0
        self.selected_scroll = 0
        self.selected_index = 0
        self.content_scroll = 0

        # Search panel state
        self.search_active = False

        # Threading
        self.loading = True
        self.generation_in_progress = False

        # Initialize
        Theme.init_colors()
        curses.curs_set(0)
        self.stdscr.timeout(100)

        threading.Thread(target=self._load_templates, daemon=True).start()

    def _set_status_message(self, message: str, is_error: bool = False) -> None:
        """Set status message with timestamp"""
        if is_error:
            self.error_message = message
            self.status_message = ""
        else:
            self.status_message = message
            self.error_message = ""
        self.message_timestamp = time.time()

    def _load_usage_data(self) -> None:
        """Load usage statistics from file with error handling"""
        try:
            usage_file = Path.home() / '.gitignore_tui_usage.json'
            if usage_file.exists():
                with open(usage_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    self.template_usage = data.get('usage', {})
                    self.recently_used = data.get('recently_used', [])
                    if not isinstance(self.template_usage, dict):
                        self.template_usage = {}
                    if not isinstance(self.recently_used, list):
                        self.recently_used = []
        except (FileNotFoundError, json.JSONDecodeError, PermissionError):
            self.template_usage = {}
            self.recently_used = []

    def _save_usage_data(self) -> None:
        """Save usage statistics to file with error handling"""
        try:
            usage_file = Path.home() / '.gitignore_tui_usage.json'
            data = {
                'usage': self.template_usage,
                'recently_used': self.recently_used
            }
            with open(usage_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2)
        except (PermissionError, OSError) as e:
            self._set_status_message(f"Warning: Could not save usage data: {e}", is_error=True)

    def _track_template_usage(self, template: str) -> None:
        """Track when a template is used"""
        self.template_usage[template] = self.template_usage.get(template, 0) + 1

        if template in self.recently_used:
            self.recently_used.remove(template)
        self.recently_used.insert(0, template)

        self.recently_used = self.recently_used[:10]

        self._save_usage_data()

    def _load_templates(self) -> None:
        """Load templates from API in background thread"""
        try:
            self.templates = GitIgnoreAPI.list_templates()
            self.templates.sort(key=str.lower)
            self._filter_templates()
            self._set_status_message(f"✓ Loaded {len(self.templates)} templates")
            self.loading = False
        except Exception as e:
            self._set_status_message(f"Failed to load templates: {e}", is_error=True)
            self.loading = False

    def _generate_content(self) -> None:
        """Generate gitignore content in background thread"""
        if not self.selected_templates:
            self.generated_content = "# No templates selected\n# Select templates from the Available Templates panel"
            return

        self.generation_in_progress = True
        try:
            selected_list = sorted(list(self.selected_templates))
            self._set_status_message(f"Generating content for {len(selected_list)} templates...")

            self.generated_content = GitIgnoreAPI.get_templates(selected_list)
            self._set_status_message(f"✓ Generated content for {len(selected_list)} templates")
        except Exception as e:
            error_msg = str(e)
            self.generated_content = f"# Error generating content: {error_msg}\n# Selected templates: {selected_list}"
            self._set_status_message(f"Generation failed: {error_msg}", is_error=True)
        finally:
            self.generation_in_progress = False

    def _filter_templates(self) -> None:
        """Filter templates based on filter text using fuzzy search"""
        if not self.filter_text:
            self.filtered_templates = self.templates[:]
        else:
            self.filtered_templates = self._filter_templates_by_text(self.templates)

        if self.template_selected >= len(self.filtered_templates):
            self.template_selected = max(0, len(self.filtered_templates) - 1)

    def _filter_templates_by_text(self, templates_list: List[str]) -> List[str]:
        """Filter templates using fuzzy search with alphabetical secondary sort"""
        if not self.filter_text:
            return sorted(templates_list, key=str.lower)

        matches = []
        for template in templates_list:
            is_match, score = fuzzy_search(self.filter_text, template)
            if is_match:
                usage_boost = self.template_usage.get(template, 0) * 10
                total_score = score + usage_boost
                matches.append((template, total_score))

        matches.sort(key=lambda x: (-x[1], x[0].lower()))
        return [match[0] for match in matches]

    def _draw_border(self, y, x, height, width, title="", is_active=False):
        """Draw a border with optional title and active highlighting"""
        try:
            border_color = Theme.get_color(Theme.HIGHLIGHT) if is_active else Theme.get_color(Theme.BORDER)
            border_attr = border_color | curses.A_BOLD if is_active else border_color

            self.stdscr.addch(y, x, "┌", border_attr)
            self.stdscr.addch(y, x + width - 1, "┐", border_attr)
            self.stdscr.addch(y + height - 1, x, "└", border_attr)
            self.stdscr.addch(y + height - 1, x + width - 1, "┘", border_attr)

            for i in range(1, width - 1):
                self.stdscr.addch(y, x + i, "─", border_attr)
                self.stdscr.addch(y + height - 1, x + i, "─", border_attr)

            for i in range(1, height - 1):
                self.stdscr.addch(y + i, x, "│", border_attr)
                self.stdscr.addch(y + i, x + width - 1, "│", border_attr)

            if title:
                title_text = f" {title} "
                title_x = x + (width - len(title_text)) // 2
                title_attr = Theme.get_color(Theme.TITLE) | curses.A_BOLD
                if is_active:
                    title_attr = Theme.get_color(Theme.HIGHLIGHT) | curses.A_BOLD
                self.stdscr.addstr(y, title_x, title_text, title_attr)
        except curses.error:
            pass

    def _draw_search_panel(self, y, x, height, width):
        """Draw the search panel"""
        is_active = self.current_panel == 0
        self._draw_border(y, x, height, width, "Search", is_active)

        inner_y, inner_x = y + 1, x + 1
        inner_width = width - 2

        search_text = self.filter_text
        prompt = "> "
        display_text = prompt + search_text

        if is_active:
            display_text += "_"

        try:
            if is_active:
                attr = Theme.get_color(Theme.SELECTED) | curses.A_BOLD
            else:
                attr = Theme.get_color(Theme.NORMAL)

            self.stdscr.addstr(inner_y, inner_x, " " * (inner_width - 1), attr)
            self.stdscr.addstr(inner_y, inner_x, display_text[:inner_width-1], attr)
        except curses.error:
            pass

    def _draw_templates_panel(self, y, x, height, width):
        """Draw the templates list panel with scroll information"""
        is_active = self.current_panel == 1

        title = "Available Templates"

        scroll_info = ""
        if self.filtered_templates:
            visible_count = height - 4
            if len(self.filtered_templates) > visible_count:
                first_visible = self.template_scroll + 1
                last_visible = min(self.template_scroll + visible_count, len(self.filtered_templates))
                scroll_info = f" ({first_visible}-{last_visible}/{len(self.filtered_templates)})"
                if len(title) + len(scroll_info) > width - 6:
                    scroll_info = f" ({first_visible}-{last_visible})"
                    if len(title) + len(scroll_info) > width - 6:
                        scroll_info = ""

        full_title = title + scroll_info
        self._draw_border(y, x, height, width, full_title, is_active)
        inner_y, inner_x = y + 1, x + 1
        inner_height, inner_width = height - 2, width - 2

        if self.loading:
            try:
                self.stdscr.addstr(inner_y + inner_height // 2, inner_x + 2,
                                    "Loading templates...", Theme.get_color(Theme.STATUS))
            except curses.error:
                pass
            return

        self._draw_list_view(inner_y, inner_x, inner_height, inner_width)

    def _draw_list_view(self, y, x, height, width):
        """Draw regular list view of templates with scroll bar"""
        count_text = f"[{len(self.filtered_templates)} templates]"
        try:
            self.stdscr.addstr(y, x + 1, count_text, Theme.get_color(Theme.BORDER))
            y += 1
            height -= 1
        except curses.error:
            pass

        if not self.filtered_templates:
            try:
                if self.filter_text:
                    no_match_text = f"No matches for '{self.filter_text}'"
                else:
                    no_match_text = "No templates found"
                self.stdscr.addstr(y + height // 2, x + 2,
                                    no_match_text, Theme.get_color(Theme.ERROR))
            except curses.error:
                pass
            return

        visible_count = height
        show_scrollbar = len(self.filtered_templates) > visible_count
        content_width = width - 2
        if show_scrollbar:
            content_width -= 2

        if self.template_selected < self.template_scroll:
            self.template_scroll = self.template_selected
        elif self.template_selected >= self.template_scroll + visible_count:
            self.template_scroll = self.template_selected - visible_count + 1

        for i in range(visible_count):
            template_idx = self.template_scroll + i
            if template_idx >= len(self.filtered_templates):
                break

            template = self.filtered_templates[template_idx]
            display_y = y + i

            is_selected = template_idx == self.template_selected and self.current_panel == 1
            is_checked = template in self.selected_templates

            attr = Theme.get_color(Theme.NORMAL)
            if is_selected:
                attr = Theme.get_color(Theme.SELECTED)

            prefix = "✓ " if is_checked else "  "
            display_text = prefix + template

            try:
                display_line = display_text[:content_width].ljust(content_width)
                self.stdscr.addstr(display_y, x + 1, display_line, attr)
            except curses.error:
                pass

        if show_scrollbar:
            scrollbar_x = x + width - 1

            self._draw_scrollbar(y, scrollbar_x, height,
                                len(self.filtered_templates), visible_count, self.template_scroll)

    def _draw_selected_panel(self, y, x, height, width):
        """Draw the selected templates panel with scroll information"""
        is_active = self.current_panel == 2
        title = "Selected Templates"

        selected_list = sorted(list(self.selected_templates))
        scroll_info = ""
        if selected_list:
            visible_count = height - 2
            if len(selected_list) > visible_count:
                first_visible = self.selected_scroll + 1
                last_visible = min(self.selected_scroll + visible_count, len(selected_list))
                scroll_info = f" ({first_visible}-{last_visible}/{len(selected_list)})"
                if len(title) + len(scroll_info) > width - 6:
                    scroll_info = f" ({first_visible}-{last_visible})"
                    if len(title) + len(scroll_info) > width - 6:
                        scroll_info = ""

        full_title = title + scroll_info
        self._draw_border(y, x, height, width, full_title, is_active)

        inner_y, inner_x = y + 1, x + 1
        inner_height, inner_width = height - 2, width - 2

        selected_list = list(self.selected_templates)

        if not selected_list:
            try:
                self.stdscr.addstr(inner_y + 1, inner_x + 2,
                                    "No templates selected", Theme.get_color(Theme.STATUS))
            except curses.error:
                pass
            return

        selected_list = sorted(list(self.selected_templates))

        if not selected_list:
            try:
                self.stdscr.addstr(inner_y + 1, inner_x + 2,
                                    "No templates selected", Theme.get_color(Theme.STATUS))
                self.stdscr.addstr(inner_y + 2, inner_x + 2,
                                    "Select templates from the left panel", Theme.get_color(Theme.STATUS))
            except curses.error:
                pass
            return

        visible_count = inner_height
        show_scrollbar = len(selected_list) > visible_count
        content_width = inner_width - 2
        if show_scrollbar:
            content_width -= 2

        if self.selected_index < self.selected_scroll:
            self.selected_scroll = self.selected_index
        elif self.selected_index >= self.selected_scroll + visible_count:
            self.selected_scroll = self.selected_index - visible_count + 1

        if self.selected_index >= len(selected_list):
            self.selected_index = max(0, len(selected_list) - 1)

        for i in range(visible_count):
            item_idx = self.selected_scroll + i
            if item_idx >= len(selected_list):
                break

            template = selected_list[item_idx]
            display_y = inner_y + i

            is_highlighted = (item_idx == self.selected_index and self.current_panel == 2)

            if is_highlighted:
                attr = Theme.get_color(Theme.SELECTED)
                prefix = "► "
            else:
                attr = Theme.get_color(Theme.SUCCESS)
                prefix = "• "

            try:
                display_text = prefix + template
                display_line = display_text[:content_width].ljust(content_width)
                self.stdscr.addstr(display_y, inner_x + 1, display_line, attr)
            except curses.error:
                pass

        if show_scrollbar:
            scrollbar_x = inner_x + inner_width - 1
            self._draw_scrollbar(inner_y, scrollbar_x, inner_height,
                                len(selected_list), visible_count, self.selected_scroll)

    def _draw_scrollbar(self, y, x, height, total_items, visible_items, scroll_position):
        """Draw a vertical scroll bar"""
        if total_items <= visible_items:
            return

        bar_height = height
        thumb_height = max(1, int((visible_items / total_items) * bar_height))
        thumb_position = int((scroll_position / max(1, total_items - visible_items)) * (bar_height - thumb_height))

        for i in range(bar_height):
            track_y = y + i
            try:
                if i >= thumb_position and i < thumb_position + thumb_height:
                    self.stdscr.addch(track_y, x, "█", Theme.get_color(Theme.HIGHLIGHT))
                else:
                    self.stdscr.addch(track_y, x, "░", Theme.get_color(Theme.BORDER))
            except curses.error:
                pass

    def _draw_content_panel(self, y, x, height, width):
        """Draw the generated content panel with scroll bar"""
        title = "Generated .gitignore"
        if self.generation_in_progress:
            title += " (Generating...)"

        is_active = self.current_panel == 3
        self._draw_border(y, x, height, width, title, is_active)

        inner_y, inner_x = y + 1, x + 1
        inner_height, inner_width = height - 2, width - 2

        if not self.generated_content:
            try:
                self.stdscr.addstr(inner_y + inner_height // 2, inner_x + 2,
                                    "Select templates to generate content",
                                    Theme.get_color(Theme.STATUS))
            except curses.error:
                pass
            return

        lines = self.generated_content.split('\n')
        content_width = inner_width - 2
        show_scrollbar = len(lines) > inner_height
        if show_scrollbar:
            content_width -= 2

        for i in range(inner_height):
            line_idx = self.content_scroll + i
            if line_idx >= len(lines):
                break

            line = lines[line_idx]
            try:
                self.stdscr.addstr(inner_y + i, inner_x + 1,
                                    line[:content_width], Theme.get_color(Theme.NORMAL))
            except curses.error:
                pass

        if show_scrollbar:
            scrollbar_x = inner_x + inner_width - 1
            self._draw_scrollbar(inner_y, scrollbar_x, inner_height,
                                len(lines), inner_height, self.content_scroll)

            scroll_info = f" ({self.content_scroll + 1}-{min(self.content_scroll + inner_height, len(lines))}/{len(lines)})"
            try:
                info_x = x + len(title) + 2
                if info_x + len(scroll_info) < x + width - 1:
                    self.stdscr.addstr(y, info_x, scroll_info, Theme.get_color(Theme.BORDER))
            except curses.error:
                pass

    def _generate_header(self):
        """Generate header comment for .gitignore file"""
        timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
        selected_list = sorted(list(self.selected_templates))
        templates_str = ", ".join(selected_list)

        header = f"""# .gitignore file generated by MKAbuMattar.com
# Generated on: {timestamp}
# Templates used: {templates_str}
#
# This file was created using the GitIgnore TUI tool
# Visit: https://github.com/MKAbuMattar/powershell-profile
#
# ================================================================

"""
        return header

    def _save_gitignore(self):
        """Save generated content to .gitignore file"""
        if not self.generated_content or self.generated_content.startswith("# No templates selected"):
            self._set_status_message("No content to save - select templates first", is_error=True)
            return

        try:
            gitignore_path = Path(".gitignore")

            if gitignore_path.exists():
                self._show_save_confirmation(gitignore_path)
            else:
                content_with_header = self._generate_header() + self.generated_content
                gitignore_path.write_text(content_with_header, encoding='utf-8')
                self._set_status_message(f"✓ Saved to {gitignore_path.name} ({len(content_with_header)} chars)")

        except Exception as e:
            self._set_status_message(f"Failed to save: {e}", is_error=True)

    def _show_save_confirmation(self, gitignore_path):
        """Show save confirmation dialog"""
        max_y, max_x = self.stdscr.getmaxyx()
        dialog_width = 60
        dialog_height = 12
        dialog_y = (max_y - dialog_height) // 2
        dialog_x = (max_x - dialog_width) // 2

        if dialog_y < 0 or dialog_x < 0:
            dialog_width = min(dialog_width, max_x - 4)
            dialog_height = min(dialog_height, max_y - 4)
            dialog_y = (max_y - dialog_height) // 2
            dialog_x = (max_x - dialog_width) // 2

        for y in range(dialog_y, dialog_y + dialog_height):
            for x in range(dialog_x, dialog_x + dialog_width):
                try:
                    self.stdscr.addch(y, x, ' ', Theme.get_color(Theme.SUCCESS))
                except curses.error:
                    pass

        self._draw_border(dialog_y, dialog_x, dialog_height, dialog_width, "Save Confirmation", False)

        try:
            for y in range(dialog_y + 1, dialog_y + dialog_height + 1):
                if y < max_y and dialog_x + dialog_width < max_x:
                    self.stdscr.addch(y, dialog_x + dialog_width, '▓', Theme.get_color(Theme.BORDER))
            for x in range(dialog_x + 1, dialog_x + dialog_width + 1):
                if dialog_y + dialog_height < max_y and x < max_x:
                    self.stdscr.addch(dialog_y + dialog_height, x, '▓', Theme.get_color(Theme.BORDER))
        except curses.error:
            pass

        content_lines = [
            "",
            ".gitignore file already exists!",
            "",
            "What would you like to do?",
            "",
            "Options:",
            "  [Y]es     - Overwrite the existing file",
            "  [N]o      - Cancel the save operation",
            "  [A]ppend  - Add content to existing file",
            "",
            "Press Y, N, or A to choose..."
        ]

        for i, line in enumerate(content_lines):
            if i >= dialog_height - 2:
                break

            content_y = dialog_y + 1 + i
            content_x = dialog_x + 2

            try:
                if line.startswith(".gitignore file already exists!"):
                    attr = Theme.get_color(Theme.ERROR) | curses.A_BOLD
                elif line.startswith("What would you like to do?"):
                    attr = Theme.get_color(Theme.TITLE) | curses.A_BOLD
                elif line.startswith("Options:"):
                    attr = Theme.get_color(Theme.HIGHLIGHT) | curses.A_BOLD
                elif line.startswith("  ["):
                    attr = Theme.get_color(Theme.NORMAL) | curses.A_BOLD
                elif line.startswith("Press Y, N, or A"):
                    attr = Theme.get_color(Theme.BORDER) | curses.A_BOLD
                else:
                    attr = Theme.get_color(Theme.NORMAL)

                display_line = line[:dialog_width-4]
                self.stdscr.addstr(content_y, content_x, display_line, attr)
            except curses.error:
                pass

        self.stdscr.refresh()

        while True:
            key = self.stdscr.getch()
            if key in (ord('y'), ord('Y')):
                try:
                    content_with_header = self._generate_header() + self.generated_content
                    gitignore_path.write_text(content_with_header, encoding='utf-8')
                    self._set_status_message(f"✓ Overwritten {gitignore_path.name} ({len(content_with_header)} chars)")
                except Exception as e:
                    self._set_status_message(f"Failed to save: {e}", is_error=True)
                break
            elif key in (ord('n'), ord('N'), 27):
                self._set_status_message("Save cancelled")
                break
            elif key in (ord('a'), ord('A')):
                try:
                    with open(gitignore_path, 'a', encoding='utf-8') as f:
                        f.write(f"\n\n# Added by MKAbuMattar.com on {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
                        f.write(f"# Templates: {', '.join(sorted(self.selected_templates))}\n")
                        f.write("# ================================================================\n\n")
                        f.write(self.generated_content)
                    content_size = len(self.generated_content)
                    self._set_status_message(f"✓ Appended to {gitignore_path.name} ({content_size} chars)")
                except Exception as e:
                    self._set_status_message(f"Failed to append: {e}", is_error=True)
                break

    def _handle_input(self, key):
        """Handle keyboard input with fzf-like search behavior"""

        if key in (ord('q'), ord('Q'), 27):
            if self.current_panel != 0:
                self.running = False
            else:
                char = chr(key)
                self.filter_text += char
                self._filter_templates()
                self.template_selected = 0
                self.template_scroll = 0
            return

        elif key == ord('\t'):
            self.current_panel = (self.current_panel + 1) % 4
            return

        elif self.current_panel == 0:
            if key in (8, 127):
                if self.filter_text:
                    self.filter_text = self.filter_text[:-1]
                    self._filter_templates()
                    self.template_selected = 0
                    self.template_scroll = 0
                return
            elif 32 <= key <= 126:
                char = chr(key)
                self.filter_text += char
                self._filter_templates()
                self.template_selected = 0
                self.template_scroll = 0
                return
            return

        elif key == ord('i'):
            self._show_info_dialog()
            return

        elif key == ord('s'):
            self._save_gitignore()
            return

        elif key == ord('r'):
            self.loading = True
            self._set_status_message("Refreshing templates...")
            threading.Thread(target=self._load_templates, daemon=True).start()
            return

        elif key == ord('c'):
            self.selected_templates.clear()
            self.generated_content = ""
            self.selected_index = 0
            self.selected_scroll = 0
            self._set_status_message("Cleared all selections")
            return

        elif key == ord('/'):
            self.current_panel = 0
            self._set_status_message("Search mode - Type to filter templates")
            return

        elif key == curses.KEY_UP:
            if self.current_panel == 1:
                if self.filtered_templates:
                    self.template_selected = max(0, self.template_selected - 1)
            elif self.current_panel == 2:
                if self.selected_templates:
                    self.selected_index = max(0, self.selected_index - 1)
            elif self.current_panel == 3:
                self.content_scroll = max(0, self.content_scroll - 1)
            return

        elif key == curses.KEY_DOWN:
            if self.current_panel == 1:
                if self.filtered_templates:
                    self.template_selected = min(len(self.filtered_templates) - 1,
                                                self.template_selected + 1)
            elif self.current_panel == 2:
                if self.selected_templates:
                    selected_count = len(self.selected_templates)
                    self.selected_index = min(selected_count - 1, self.selected_index + 1)
            elif self.current_panel == 3:
                content_lines = len(self.generated_content.split('\n')) if self.generated_content else 0
                max_y, max_x = self.stdscr.getmaxyx()
                content_height = max_y - 6
                max_scroll = max(0, content_lines - content_height)
                self.content_scroll = min(max_scroll, self.content_scroll + 1)
            return

        elif key in (ord(' '), ord('\n'), ord('\r')):
            if self.current_panel == 1:
                if self.filtered_templates:
                    template = self.filtered_templates[self.template_selected]
                    if template in self.selected_templates:
                        self.selected_templates.remove(template)
                    else:
                        self.selected_templates.add(template)
                        self._track_template_usage(template)
                    threading.Thread(target=self._generate_content, daemon=True).start()

            elif self.current_panel == 2:
                if self.selected_templates:
                    selected_list = sorted(list(self.selected_templates))
                    if self.selected_index < len(selected_list):
                        template_to_remove = selected_list[self.selected_index]
                        self.selected_templates.remove(template_to_remove)
                        if self.selected_index >= len(self.selected_templates):
                            self.selected_index = max(0, len(self.selected_templates) - 1)
                        threading.Thread(target=self._generate_content, daemon=True).start()
            return

        current_time = time.time()
        if self.error_message and current_time - self.message_timestamp > 5:
            self.error_message = ""
        elif self.status_message and not ("✓" in self.status_message or "Saved" in self.status_message) and current_time - self.message_timestamp > 3:
            if key != -1:
                pass

    def _draw_status_bar(self):
        """Draw the status bar at the bottom"""
        max_y, max_x = self.stdscr.getmaxyx()
        status_y = max_y - 1

        try:
            self.stdscr.addstr(status_y, 0, " " * (max_x - 1), Theme.get_color(Theme.STATUS))
        except curses.error:
            pass

        panel_names = ["Search", "Templates", "Selected", "Content"]
        active_panel = panel_names[self.current_panel]

        if self.current_panel == 0:
            controls = f"[{active_panel}] Type to Search | Tab Switch | Backspace Clear"
        elif self.current_panel == 1:
            controls = f"[{active_panel}] ↑↓ Nav | Space Select | i Info | q Quit"
        elif self.current_panel == 2:
            controls = f"[{active_panel}] ↑↓ Nav | Space Remove | s Save | i Info | q Quit"
        else:
            controls = f"[{active_panel}] ↑↓ Scroll | s Save | i Info | q Quit"

        message = self.error_message if self.error_message else self.status_message

        try:
            self.stdscr.addstr(status_y, 1, controls[:max_x//2-2], Theme.get_color(Theme.STATUS))

            if message:
                max_msg_len = max_x//2 - 5
                display_msg = message[:max_msg_len] if len(message) > max_msg_len else message
                msg_x = max_x - len(display_msg) - 2

                if self.error_message:
                    msg_attr = Theme.get_color(Theme.ERROR) | curses.A_BOLD
                elif "✓" in message or "Saved" in message:
                    msg_attr = Theme.get_color(Theme.SUCCESS) | curses.A_BOLD
                else:
                    msg_attr = Theme.get_color(Theme.HIGHLIGHT)

                self.stdscr.addstr(status_y, msg_x, display_msg, msg_attr)
        except curses.error:
            pass

    def _show_info_dialog(self):
        """Show application information dialog"""
        max_y, max_x = self.stdscr.getmaxyx()

        dialog_width = 70
        dialog_height = 26
        dialog_y = (max_y - dialog_height) // 2
        dialog_x = (max_x - dialog_width) // 2

        if dialog_y < 0 or dialog_x < 0:
            dialog_width = min(dialog_width, max_x - 4)
            dialog_height = min(dialog_height, max_y - 4)
            dialog_y = (max_y - dialog_height) // 2
            dialog_x = (max_x - dialog_width) // 2

        for y in range(dialog_y, dialog_y + dialog_height):
            for x in range(dialog_x, dialog_x + dialog_width):
                try:
                    self.stdscr.addch(y, x, ' ', Theme.get_color(Theme.NORMAL))
                except curses.error:
                    pass

        self._draw_border(dialog_y, dialog_x, dialog_height, dialog_width, "GitIgnore TUI - Information", False)

        try:
            for y in range(dialog_y + 1, dialog_y + dialog_height + 1):
                if y < max_y and dialog_x + dialog_width < max_x:
                    self.stdscr.addch(y, dialog_x + dialog_width, '▓', Theme.get_color(Theme.BORDER))
            for x in range(dialog_x + 1, dialog_x + dialog_width + 1):
                if dialog_y + dialog_height < max_y and x < max_x:
                    self.stdscr.addch(dialog_y + dialog_height, x, '▓', Theme.get_color(Theme.BORDER))
        except curses.error:
            pass

        info_lines = [
            "",
            "GitIgnore TUI v4.1.0",
            "Text User Interface for GitIgnore Template Generator",
            "",
            "Author: Mohammad Abu Mattar",
            "Website: MKAbuMattar.com",
            "GitHub: github.com/MKAbuMattar/powershell-profile",
            "",
            "Description:",
            "  Interactive tool for generating .gitignore files",
            "  using templates from gitignore.io API",
            "",
            "Controls:",
            "  ↑/↓       Navigate lists",
            "  Space     Select/deselect template (Templates panel)",
            "            Remove template (Selected panel)",
            "  Tab       Switch between panels",
            "  s         Save .gitignore file",
            "  r         Refresh templates",
            "  c         Clear all selections",
            "  /         Filter templates (fuzzy search)",
            "  i         Show this info",
            "  q/Esc     Quit application",
            "",
            "Features:",
            "  ✓ Fuzzy search with usage-based ranking",
            "  ✓ Usage tracking and recently used templates",
            "  ✓ Alphabetical sorting for easy browsing",
            "",
            "═══════════════════════════════════════════════════════",
            "Press ANY key to close this dialog..."
        ]

        available_content_height = dialog_height - 2
        for i, line in enumerate(info_lines):
            if i >= available_content_height:
                break

            content_y = dialog_y + 1 + i
            content_x = dialog_x + 2

            if content_y >= dialog_y + dialog_height - 1:
                break

            try:
                if line.startswith("GitIgnore TUI"):
                    attr = Theme.get_color(Theme.TITLE) | curses.A_BOLD
                elif line.startswith("Author:") or line.startswith("Website:") or line.startswith("GitHub:"):
                    attr = Theme.get_color(Theme.HIGHLIGHT) | curses.A_BOLD
                elif line.startswith("Description:") or line.startswith("Controls:") or line.startswith("Features:"):
                    attr = Theme.get_color(Theme.SUCCESS) | curses.A_BOLD
                elif line.startswith("  ") and any(ctrl in line for ctrl in ["↑/↓", "Space", "Tab", "s", "r", "c", "/", "i", "q/Esc", "✓"]):
                    attr = Theme.get_color(Theme.BORDER)
                elif line.startswith("Press ANY key") or "═══" in line:
                    attr = Theme.get_color(Theme.ERROR) | curses.A_BOLD
                else:
                    attr = Theme.get_color(Theme.NORMAL)

                display_line = line[:dialog_width-4]
                self.stdscr.addstr(content_y, content_x, display_line, attr)
            except curses.error:
                pass

        self.stdscr.refresh()
        self.stdscr.timeout(-1)
        curses.flushinp()

        while True:
            key = self.stdscr.getch()
            if key != -1 and key != curses.ERR:
                break

        self.stdscr.timeout(100)

    def render(self):
        """Main render loop"""
        try:
            self.stdscr.clear()
            max_y, max_x = self.stdscr.getmaxyx()

            left_width = max_x // 3
            right_width = max_x - left_width
            bottom_height = 6
            search_height = 3
            templates_height = max_y - bottom_height - search_height - 1

            self._draw_search_panel(0, 0, search_height, left_width)
            self._draw_templates_panel(search_height, 0, templates_height, left_width)
            self._draw_content_panel(0, left_width, max_y - bottom_height - 1, right_width)
            self._draw_selected_panel(max_y - bottom_height - 1, 0, bottom_height, max_x)
            self._draw_status_bar()

            self.stdscr.refresh()

        except curses.error:
            pass

    def run(self) -> None:
        """Main application loop"""
        while self.running:
            self.render()

            try:
                key = self.stdscr.getch()
                if key != -1:
                    self._handle_input(key)
            except curses.error:
                pass

            time.sleep(0.01)


def main() -> None:
    """Main entry point with proper error handling"""
    try:
        curses.wrapper(lambda stdscr: GitIgnoreTUI(stdscr).run())
    except KeyboardInterrupt:
        print("\n✓ GitIgnore TUI closed by user")
        sys.exit(0)
    except Exception as e:
        print(f"✗ Error running GitIgnore TUI: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
