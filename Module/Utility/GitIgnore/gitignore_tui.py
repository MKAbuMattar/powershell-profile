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
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

"""
GitIgnore Template Generator TUI

A Terminal User Interface for generating .gitignore templates using the gitignore.io API.
Features a three-panel layout: templates list, selected items, and generated content.

Usage:
```bash
python gitignore_tui.py
```

Controls:
- Arrow keys: Navigate template list and selected items
- Space/Enter: Select/deselect template (Templates panel)
              Remove template (Selected panel)
- Tab: Switch between panels
- s: Save generated .gitignore file
- /: Filter templates
- i: Show app information
- r: Refresh templates list
- c: Clear all selections
- q/Esc: Quit application
"""

import curses
import sys
import threading
import time
from typing import List, Optional, Set
import urllib.request
import urllib.error
from pathlib import Path


class GitIgnoreAPI:
    """Client for gitignore.io API"""

    BASE_URL = "https://www.toptal.com/developers/gitignore/api"
    TIMEOUT = 10

    @staticmethod
    def fetch_url(url: str) -> str:
        """Fetch content from URL"""
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=GitIgnoreAPI.TIMEOUT) as response:
                return response.read().decode("utf-8")
        except urllib.error.URLError as e:
            raise RuntimeError(f"Failed to fetch {url}: {e}")

    @staticmethod
    def get_templates(technologies: List[str]) -> str:
        """Get gitignore content for specified technologies"""
        if not technologies:
            return ""

        # Ensure clean technology names
        clean_techs = []
        for tech in technologies:
            clean_tech = str(tech).strip().replace('\n', '').replace('\r', '').replace('\t', '')
            if clean_tech:  # Only add non-empty strings
                clean_techs.append(clean_tech)

        if not clean_techs:
            return "# No valid templates provided"

        tech_string = ",".join(clean_techs).lower()
        url = f"{GitIgnoreAPI.BASE_URL}/{tech_string}"

        # Debug: Print the URL being used
        print(f"API URL: {url}", file=sys.stderr)

        return GitIgnoreAPI.fetch_url(url)

    @staticmethod
    def list_templates() -> List[str]:
        """Get list of available templates"""
        url = f"{GitIgnoreAPI.BASE_URL}/list"
        response = GitIgnoreAPI.fetch_url(url)

        # Split by both commas and newlines, then clean each template
        all_templates = []

        # First split by newlines, then by commas
        lines = response.strip().split('\n')
        for line in lines:
            templates_in_line = line.split(',')
            for template in templates_in_line:
                clean_template = template.strip()
                if clean_template:  # Only add non-empty templates
                    all_templates.append(clean_template)

        return sorted(all_templates)


class Theme:
    """Color theme for the TUI"""

    # Color pairs
    NORMAL = 1
    SELECTED = 2
    BORDER = 3
    TITLE = 4
    STATUS = 5
    ERROR = 6
    SUCCESS = 7
    HIGHLIGHT = 8

    @staticmethod
    def init_colors():
        """Initialize color pairs"""
        if not curses.has_colors():
            return

        curses.start_color()
        curses.use_default_colors()

        # Define color pairs
        curses.init_pair(Theme.NORMAL, curses.COLOR_WHITE, -1)
        curses.init_pair(Theme.SELECTED, curses.COLOR_BLACK, curses.COLOR_CYAN)
        curses.init_pair(Theme.BORDER, curses.COLOR_BLUE, -1)
        curses.init_pair(Theme.TITLE, curses.COLOR_YELLOW, -1)
        curses.init_pair(Theme.STATUS, curses.COLOR_GREEN, -1)
        curses.init_pair(Theme.ERROR, curses.COLOR_RED, -1)
        curses.init_pair(Theme.SUCCESS, curses.COLOR_GREEN, -1)
        curses.init_pair(Theme.HIGHLIGHT, curses.COLOR_MAGENTA, -1)

    @staticmethod
    def get_color(color_id):
        """Get color pair"""
        return curses.color_pair(color_id)


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

        # UI state
        self.current_panel = 0  # 0: templates, 1: selected, 2: content
        self.template_scroll = 0
        self.template_selected = 0
        self.selected_scroll = 0  # Scroll position for selected templates panel
        self.selected_index = 0   # Currently highlighted item in selected panel
        self.content_scroll = 0

        # Threading
        self.loading = True
        self.generation_in_progress = False

        # Initialize
        Theme.init_colors()
        curses.curs_set(0)
        self.stdscr.timeout(100)  # Non-blocking input with 100ms timeout

        # Start loading templates in background
        threading.Thread(target=self._load_templates, daemon=True).start()

    def _set_status_message(self, message, is_error=False):
        """Set status message with timestamp"""
        if is_error:
            self.error_message = message
            self.status_message = ""
        else:
            self.status_message = message
            self.error_message = ""
        self.message_timestamp = time.time()

    def _load_templates(self):
        """Load templates from API in background thread"""
        try:
            self.templates = GitIgnoreAPI.list_templates()
            self.filtered_templates = self.templates[:]
            self._set_status_message(f"✓ Loaded {len(self.templates)} templates")
            self.loading = False
        except Exception as e:
            self._set_status_message(f"Failed to load templates: {e}", is_error=True)
            self.loading = False

    def _generate_content(self):
        """Generate gitignore content in background thread"""
        if not self.selected_templates:
            self.generated_content = "# No templates selected\n# Select templates from the left panel"
            return

        self.generation_in_progress = True
        try:
            # Templates are already clean from API parsing
            selected_list = list(self.selected_templates)

            # Debug: Add status message to show what we're sending
            tech_string = ",".join(selected_list).lower()
            self._set_status_message(f"Generating for: {tech_string}")

            self.generated_content = GitIgnoreAPI.get_templates(selected_list)
            self._set_status_message(f"✓ Generated for {len(selected_list)} templates")
        except Exception as e:
            # Show more detailed error information
            error_msg = str(e)
            self.generated_content = f"# Error generating content: {error_msg}\n# Selected templates: {list(self.selected_templates)}"
            self._set_status_message(f"Generation failed: {error_msg}", is_error=True)
        finally:
            self.generation_in_progress = False

    def _filter_templates(self):
        """Filter templates based on filter text"""
        if not self.filter_text:
            self.filtered_templates = self.templates[:]
        else:
            self.filtered_templates = [
                t for t in self.templates
                if self.filter_text.lower() in t.lower()
            ]

        # Reset selection if out of bounds
        if self.template_selected >= len(self.filtered_templates):
            self.template_selected = max(0, len(self.filtered_templates) - 1)

    def _draw_border(self, y, x, height, width, title="", is_active=False):
        """Draw a border with optional title and active highlighting"""
        try:
            # Choose border color based on active state
            border_color = Theme.get_color(Theme.HIGHLIGHT) if is_active else Theme.get_color(Theme.BORDER)
            border_attr = border_color | curses.A_BOLD if is_active else border_color

            # Draw corners and lines
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

            # Draw title with special styling for active panels
            if title:
                title_text = f" {title} "
                title_x = x + (width - len(title_text)) // 2
                title_attr = Theme.get_color(Theme.TITLE) | curses.A_BOLD
                if is_active:
                    title_attr = Theme.get_color(Theme.HIGHLIGHT) | curses.A_BOLD
                self.stdscr.addstr(y, title_x, title_text, title_attr)
        except curses.error:
            pass

    def _draw_templates_panel(self, y, x, height, width):
        """Draw the templates list panel"""
        is_active = self.current_panel == 0
        self._draw_border(y, x, height, width, "Available Templates", is_active)

        # Calculate visible area
        inner_y, inner_x = y + 1, x + 1
        inner_height, inner_width = height - 2, width - 2

        if self.loading:
            try:
                self.stdscr.addstr(inner_y + inner_height // 2, inner_x + 2,
                                 "Loading templates...", Theme.get_color(Theme.STATUS))
            except curses.error:
                pass
            return

        if not self.filtered_templates:
            try:
                self.stdscr.addstr(inner_y + inner_height // 2, inner_x + 2,
                                 "No templates found", Theme.get_color(Theme.ERROR))
            except curses.error:
                pass
            return

        # Show filter if active
        filter_y = inner_y
        if self.filter_text:
            try:
                filter_display = f"Filter: {self.filter_text}"
                self.stdscr.addstr(filter_y, inner_x + 1, filter_display[:inner_width-2],
                                 Theme.get_color(Theme.HIGHLIGHT))
                filter_y += 1
                inner_height -= 1
            except curses.error:
                pass

        # Adjust scroll
        visible_count = inner_height
        if self.template_selected < self.template_scroll:
            self.template_scroll = self.template_selected
        elif self.template_selected >= self.template_scroll + visible_count:
            self.template_scroll = self.template_selected - visible_count + 1

        # Draw templates
        for i in range(visible_count):
            template_idx = self.template_scroll + i
            if template_idx >= len(self.filtered_templates):
                break

            template = self.filtered_templates[template_idx]
            display_y = filter_y + i

            # Determine style
            is_selected = template_idx == self.template_selected and self.current_panel == 0
            is_checked = template in self.selected_templates

            attr = Theme.get_color(Theme.NORMAL)
            if is_selected:
                attr = Theme.get_color(Theme.SELECTED)

            # Prepare text
            prefix = "✓ " if is_checked else "  "
            display_text = prefix + template

            try:
                self.stdscr.addstr(display_y, inner_x + 1,
                                 display_text[:inner_width-2].ljust(inner_width-2), attr)
            except curses.error:
                pass

    def _draw_selected_panel(self, y, x, height, width):
        """Draw the selected templates panel"""
        is_active = self.current_panel == 1
        self._draw_border(y, x, height, width, "Selected Templates", is_active)

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

        # Draw selected items with navigation support
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

        # Adjust scroll for selected panel
        visible_count = inner_height
        if self.selected_index < self.selected_scroll:
            self.selected_scroll = self.selected_index
        elif self.selected_index >= self.selected_scroll + visible_count:
            self.selected_scroll = self.selected_index - visible_count + 1

        # Ensure selected_index is within bounds
        if self.selected_index >= len(selected_list):
            self.selected_index = max(0, len(selected_list) - 1)

        # Draw selected items with highlighting
        for i in range(visible_count):
            item_idx = self.selected_scroll + i
            if item_idx >= len(selected_list):
                break

            template = selected_list[item_idx]
            display_y = inner_y + i

            # Determine if this item is highlighted
            is_highlighted = (item_idx == self.selected_index and self.current_panel == 1)

            # Choose appropriate color
            if is_highlighted:
                attr = Theme.get_color(Theme.SELECTED)
                prefix = "► "
            else:
                attr = Theme.get_color(Theme.SUCCESS)
                prefix = "• "

            try:
                display_text = prefix + template
                # Fill the entire width for better highlighting
                display_line = display_text.ljust(inner_width - 2)
                self.stdscr.addstr(display_y, inner_x + 1, display_line[:inner_width-2], attr)
            except curses.error:
                pass

    def _draw_content_panel(self, y, x, height, width):
        """Draw the generated content panel"""
        title = "Generated .gitignore"
        if self.generation_in_progress:
            title += " (Generating...)"

        is_active = self.current_panel == 2
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

        # Split content into lines
        lines = self.generated_content.split('\n')

        # Draw content with scrolling
        for i in range(inner_height):
            line_idx = self.content_scroll + i
            if line_idx >= len(lines):
                break

            line = lines[line_idx]
            try:
                self.stdscr.addstr(inner_y + i, inner_x + 1,
                                 line[:inner_width-2], Theme.get_color(Theme.NORMAL))
            except curses.error:
                pass

    def _draw_status_bar(self):
        """Draw the status bar at the bottom"""
        max_y, max_x = self.stdscr.getmaxyx()
        status_y = max_y - 1

        # Clear status line
        try:
            self.stdscr.addstr(status_y, 0, " " * (max_x - 1), Theme.get_color(Theme.STATUS))
        except curses.error:
            pass

        # Show controls on left side with panel indicator and context-specific help
        panel_names = ["Templates", "Selected", "Content"]
        active_panel = panel_names[self.current_panel]

        if self.current_panel == 0:
            controls = f"[{active_panel}] ↑↓ Nav | Space Select | Tab Switch | s Save | i Info | q Quit"
        elif self.current_panel == 1:
            controls = f"[{active_panel}] ↑↓ Nav | Space Remove | Tab Switch | s Save | i Info | q Quit"
        else:  # content panel
            controls = f"[{active_panel}] ↑↓ Scroll | Tab Switch | s Save | i Info | q Quit"

        # Show status message or error on right side
        message = self.error_message if self.error_message else self.status_message

        try:
            # Draw controls on left
            self.stdscr.addstr(status_y, 1, controls[:max_x//2-2], Theme.get_color(Theme.STATUS))

            # Draw message on right with more prominence
            if message:
                # Truncate message if too long
                max_msg_len = max_x//2 - 5
                display_msg = message[:max_msg_len] if len(message) > max_msg_len else message
                msg_x = max_x - len(display_msg) - 2

                # Use different colors for different message types
                if self.error_message:
                    attr = Theme.get_color(Theme.ERROR) | curses.A_BOLD
                elif "✓" in message or "Saved" in message:
                    attr = Theme.get_color(Theme.SUCCESS) | curses.A_BOLD
                else:
                    attr = Theme.get_color(Theme.HIGHLIGHT)

                self.stdscr.addstr(status_y, msg_x, display_msg, attr)
        except curses.error:
            pass

    def _generate_header(self):
        """Generate header comment for .gitignore file"""
        timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
        # Templates are already clean from API parsing
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

            # Check if file exists and ask for confirmation
            if gitignore_path.exists():
                # Show confirmation dialog
                self._show_save_confirmation(gitignore_path)
            else:
                # Direct save for new files
                content_with_header = self._generate_header() + self.generated_content
                gitignore_path.write_text(content_with_header, encoding='utf-8')
                self._set_status_message(f"✓ Saved to {gitignore_path.name} ({len(content_with_header)} chars)")

        except Exception as e:
            self._set_status_message(f"Failed to save: {e}", is_error=True)

    def _show_save_confirmation(self, gitignore_path):
        """Show save confirmation dialog"""
        max_y, max_x = self.stdscr.getmaxyx()

        # Create confirmation dialog
        dialog_width = 60
        dialog_height = 8
        dialog_y = (max_y - dialog_height) // 2
        dialog_x = (max_x - dialog_width) // 2

        # Draw dialog background
        for y in range(dialog_y, dialog_y + dialog_height):
            for x in range(dialog_x, dialog_x + dialog_width):
                try:
                    self.stdscr.addch(y, x, ' ', Theme.get_color(Theme.SELECTED))
                except curses.error:
                    pass

        # Draw dialog border
        self._draw_border(dialog_y, dialog_x, dialog_height, dialog_width, "Save Confirmation", False)

        # Dialog content
        try:
            self.stdscr.addstr(dialog_y + 2, dialog_x + 2,
                             ".gitignore already exists!",
                             Theme.get_color(Theme.ERROR) | curses.A_BOLD)
            self.stdscr.addstr(dialog_y + 3, dialog_x + 2,
                             "Do you want to overwrite it?")
            self.stdscr.addstr(dialog_y + 5, dialog_x + 2,
                             "[Y]es  [N]o  [A]ppend",
                             Theme.get_color(Theme.HIGHLIGHT))
        except curses.error:
            pass

        self.stdscr.refresh()

        # Wait for user input
        while True:
            key = self.stdscr.getch()
            if key in (ord('y'), ord('Y')):
                # Overwrite
                try:
                    content_with_header = self._generate_header() + self.generated_content
                    gitignore_path.write_text(content_with_header, encoding='utf-8')
                    self._set_status_message(f"✓ Overwritten {gitignore_path.name} ({len(content_with_header)} chars)")
                except Exception as e:
                    self._set_status_message(f"Failed to save: {e}", is_error=True)
                break
            elif key in (ord('n'), ord('N'), 27):  # No or Esc
                self._set_status_message("Save cancelled")
                break
            elif key in (ord('a'), ord('A')):
                # Append
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
        """Handle keyboard input"""
        if key in (ord('q'), ord('Q'), 27):  # q or Esc
            self.running = False

        elif key == ord('\t'):  # Tab - switch panels
            self.current_panel = (self.current_panel + 1) % 3

        elif key == curses.KEY_UP:
            if self.current_panel == 0 and self.filtered_templates:
                self.template_selected = max(0, self.template_selected - 1)
            elif self.current_panel == 1 and self.selected_templates:
                self.selected_index = max(0, self.selected_index - 1)
            elif self.current_panel == 2:
                self.content_scroll = max(0, self.content_scroll - 1)

        elif key == curses.KEY_DOWN:
            if self.current_panel == 0 and self.filtered_templates:
                self.template_selected = min(len(self.filtered_templates) - 1,
                                           self.template_selected + 1)
            elif self.current_panel == 1 and self.selected_templates:
                selected_count = len(self.selected_templates)
                self.selected_index = min(selected_count - 1, self.selected_index + 1)
            elif self.current_panel == 2:
                content_lines = len(self.generated_content.split('\n')) if self.generated_content else 0
                max_y, max_x = self.stdscr.getmaxyx()
                content_height = max_y - 6  # Approximate content panel height
                max_scroll = max(0, content_lines - content_height)
                self.content_scroll = min(max_scroll, self.content_scroll + 1)

        elif key in (ord(' '), ord('\n'), ord('\r')):  # Space or Enter
            if self.current_panel == 0 and self.filtered_templates:
                # Add/remove from templates panel
                template = self.filtered_templates[self.template_selected]

                # Templates are already clean from the API parsing
                if template in self.selected_templates:
                    self.selected_templates.remove(template)
                else:
                    self.selected_templates.add(template)

                # Generate content in background
                threading.Thread(target=self._generate_content, daemon=True).start()

            elif self.current_panel == 1 and self.selected_templates:
                # Remove from selected panel
                selected_list = sorted(list(self.selected_templates))
                if self.selected_index < len(selected_list):
                    template_to_remove = selected_list[self.selected_index]
                    self.selected_templates.remove(template_to_remove)

                    # Adjust selected_index if needed
                    if self.selected_index >= len(self.selected_templates):
                        self.selected_index = max(0, len(self.selected_templates) - 1)

                    # Generate content in background
                    threading.Thread(target=self._generate_content, daemon=True).start()

        elif key == ord('s'):  # Save
            self._save_gitignore()

        elif key == ord('r'):  # Refresh
            self.loading = True
            self._set_status_message("Refreshing templates...")
            threading.Thread(target=self._load_templates, daemon=True).start()

        elif key == ord('c'):  # Clear selections
            self.selected_templates.clear()
            self.generated_content = ""
            self.selected_index = 0  # Reset selected panel navigation
            self.selected_scroll = 0
            self._set_status_message("Cleared all selections")

        elif key == ord('/'):  # Start filter
            self._handle_filter_input()

        elif key == ord('i'):  # Show info dialog
            self._show_info_dialog()

        # Clear error message after 5 seconds, but not success messages
        current_time = time.time()
        if self.error_message and current_time - self.message_timestamp > 5:
            self.error_message = ""
        elif self.status_message and not ("✓" in self.status_message or "Saved" in self.status_message) and current_time - self.message_timestamp > 3:
            # Clear non-success status messages after 3 seconds
            if key != -1:  # Only clear when user presses a key
                pass  # Keep message visible until user interaction

    def _handle_filter_input(self):
        """Handle filter input mode"""
        curses.echo()
        curses.curs_set(1)

        max_y, max_x = self.stdscr.getmaxyx()
        try:
            self.stdscr.addstr(max_y - 1, 0, "Filter: ", Theme.get_color(Theme.HIGHLIGHT))
            self.stdscr.refresh()

            # Get filter input
            filter_input = self.stdscr.getstr(max_y - 1, 8, 50).decode('utf-8')
            self.filter_text = filter_input
            self._filter_templates()

        except (curses.error, KeyboardInterrupt):
            pass
        finally:
            curses.noecho()
            curses.curs_set(0)

    def _show_info_dialog(self):
        """Show application information dialog"""
        max_y, max_x = self.stdscr.getmaxyx()

        # Create info dialog
        dialog_width = 70
        dialog_height = 20
        dialog_y = (max_y - dialog_height) // 2
        dialog_x = (max_x - dialog_width) // 2

        # Ensure dialog fits on screen
        if dialog_y < 0 or dialog_x < 0:
            dialog_width = min(dialog_width, max_x - 4)
            dialog_height = min(dialog_height, max_y - 4)
            dialog_y = (max_y - dialog_height) // 2
            dialog_x = (max_x - dialog_width) // 2

        # Draw dialog background with a different color
        for y in range(dialog_y, dialog_y + dialog_height):
            for x in range(dialog_x, dialog_x + dialog_width):
                try:
                    self.stdscr.addch(y, x, ' ', Theme.get_color(Theme.NORMAL))
                except curses.error:
                    pass

        # Draw dialog border
        self._draw_border(dialog_y, dialog_x, dialog_height, dialog_width, "GitIgnore TUI - Information", False)

        # Add a subtle shadow effect by drawing darker characters around the border
        try:
            for y in range(dialog_y + 1, dialog_y + dialog_height + 1):
                if y < max_y and dialog_x + dialog_width < max_x:
                    self.stdscr.addch(y, dialog_x + dialog_width, '▓', Theme.get_color(Theme.BORDER))
            for x in range(dialog_x + 1, dialog_x + dialog_width + 1):
                if dialog_y + dialog_height < max_y and x < max_x:
                    self.stdscr.addch(dialog_y + dialog_height, x, '▓', Theme.get_color(Theme.BORDER))
        except curses.error:
            pass

        # Dialog content
        info_lines = [
            "",
            "GitIgnore TUI v4.2.0",
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
            "  /         Filter templates",
            "  i         Show this info",
            "  q/Esc     Quit application",
            "",
            "═══════════════════════════════════════════════════════",
            "Press ANY key to close this dialog..."
        ]

        # Draw content
        for i, line in enumerate(info_lines):
            if i >= dialog_height - 2:  # Leave space for border
                break

            content_y = dialog_y + 1 + i
            content_x = dialog_x + 2

            try:
                # Color certain lines differently with better contrast
                if line.startswith("GitIgnore TUI"):
                    attr = Theme.get_color(Theme.TITLE) | curses.A_BOLD
                elif line.startswith("Author:") or line.startswith("Website:") or line.startswith("GitHub:"):
                    attr = Theme.get_color(Theme.HIGHLIGHT) | curses.A_BOLD
                elif line.startswith("Description:") or line.startswith("Controls:"):
                    attr = Theme.get_color(Theme.SUCCESS) | curses.A_BOLD
                elif line.startswith("  ") and any(ctrl in line for ctrl in ["↑/↓", "Space", "Tab", "s", "r", "c", "/", "i", "q/Esc"]):
                    attr = Theme.get_color(Theme.BORDER)
                elif line.startswith("Press ANY key") or "═══" in line:
                    attr = Theme.get_color(Theme.ERROR) | curses.A_BOLD
                else:
                    attr = Theme.get_color(Theme.NORMAL)

                display_line = line[:dialog_width-4]  # Leave margin
                self.stdscr.addstr(content_y, content_x, display_line, attr)
            except curses.error:
                pass

        self.stdscr.refresh()

        # Wait for any key press - temporarily disable timeout for this dialog
        self.stdscr.timeout(-1)  # Blocking mode

        # Clear any pending input
        curses.flushinp()  # Use curses.flushinp() not self.stdscr.flushinp()

        # Wait for user input
        while True:
            key = self.stdscr.getch()
            if key != -1 and key != curses.ERR:
                break

        # Restore original timeout
        self.stdscr.timeout(100)  # Restore to 100ms timeout

    def render(self):
        """Main render loop"""
        try:
            self.stdscr.clear()
            max_y, max_x = self.stdscr.getmaxyx()

            # Calculate panel dimensions
            left_width = max_x // 3
            right_width = max_x - left_width
            bottom_height = 6
            top_height = max_y - bottom_height - 1  # -1 for status bar

            # Draw panels
            self._draw_templates_panel(0, 0, top_height, left_width)
            self._draw_content_panel(0, left_width, top_height, right_width)
            self._draw_selected_panel(top_height, 0, bottom_height, max_x)
            self._draw_status_bar()

            self.stdscr.refresh()

        except curses.error:
            pass

    def run(self):
        """Main application loop"""
        while self.running:
            self.render()

            try:
                key = self.stdscr.getch()
                if key != -1:
                    self._handle_input(key)
            except curses.error:
                pass

            time.sleep(0.01)  # Small delay to prevent excessive CPU usage


def main():
    """Main entry point"""
    try:
        curses.wrapper(lambda stdscr: GitIgnoreTUI(stdscr).run())
    except KeyboardInterrupt:
        print("\nExiting GitIgnore TUI...")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
