<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Directory\README.md -->

# Directory Module

## **Module Overview:**

The Directory module is a collection of PowerShell functions designed to streamline directory navigation and file management tasks. It offers a range of functionalities from finding files and creating new ones to compressing archives and searching content within files. This module aims to provide convenient aliases and commands for common file system operations, enhancing productivity in the PowerShell environment.

## **Key Features:**

- Efficient file and directory searching.
- Easy creation and timestamp modification of files.
- Support for compressing and decompressing files (e.g., ZIP archives).
- Powerful text searching and replacement within files, supporting regular expressions.
- Enhanced directory navigation with `z` (a smart `cd` that navigates to the best match) and `zi` (interactive `cd` using fzf, if installed).
- Quick access to the beginning or end of files (functionality to be detailed if present).
- Short path retrieval for files and directories.
- Convenient aliases for moving up multiple directory levels (e.g., `...` for two levels up, `....` for three).

## **Functions:**

- **`Find-Files`** (Alias: `ff`): Finds files matching a specified name pattern in the current directory and its subdirectories.

  - _Details:_ Searches recursively for files based on the provided pattern. Supports wildcards.
  - _Example:_ `ff *.txt` finds all text files in the current directory and below.

- **`Set-FreshFile`** (Alias: `touch`): Creates a new empty file or updates the timestamp of an existing file to the current time.

  - _Details:_ If the file exists, its last write time is updated. If not, an empty file is created. Mimics the Unix `touch` command.
  - _Example:_ `touch newfile.log`

- **`Expand-File`** (Alias: `unzip`): Extracts the contents of a compressed archive (e.g., .zip) to the current directory.

  - _Details:_ Supports various common archive formats (like .zip, .tar.gz) if the necessary system utilities or PowerShell modules (like `Microsoft.PowerShell.Archive`) are present.
  - _Example:_ `unzip archive.zip`

- **`Compress-Files`** (Alias: `zip`): Compresses specified files or directories into a zip archive.

  - _Details:_ Creates a new zip file containing the listed files/directories. Can specify compression level if supported by the underlying mechanism.
  - _Example:_ `zip myarchive.zip file1.txt folder1`

- **`Get-ContentMatching`** (Alias: `grep`): Searches for a text pattern (supports regular expressions) within specified files.

  - _Details:_ Similar to the `grep` command in Unix-like systems. Can specify case sensitivity, line numbers, etc.
  - _Example:_ `grep "error" *.log` searches for "error" in all .log files.

- **`Set-ContentMatching`** (Alias: `sed`): Searches for a string in a file and replaces all occurrences with another string.

  - _Details:_ Performs in-place find and replace operations on file content. It's advisable to back up files before using this on critical data.
  - _Example:_ `sed "old_text" "new_text" config.ini`

- **`z`**: A smarter `cd` command. It navigates to a directory that best matches the provided argument using a fuzzy finding or partial matching logic. It prints the matched directory before changing to it.

  - _Details:_ Useful for quickly jumping to frequently accessed or uniquely named directories without typing the full path. May rely on a history or a predefined list of common directories.
  - _Example:_ `z myproj` might navigate to `C:\Users\YourUser\Projects\MyProject`.

- **`zi`**: An interactive version of `cd` that uses `fzf` (if installed) to provide a fuzzy-searchable list of recent or bookmarked directories to choose from.
  - _Details:_ Requires `fzf` to be installed and in PATH. Offers a highly efficient way to navigate complex directory structures.

[Back to Modules](../../README.md#modules)

**Contribution:**
Suggestions for new file/directory utilities or improvements to existing ones are welcome. Please follow the main [Contributing Guidelines](../../README.md#contributing).
