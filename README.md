# Shellman

A fast, lightweight, terminal-based file manager and editor built with [Textual](https://github.com/Textualize/textual). Runs on Linux, macOS, and Windows.

---

## Features

- Navigate your filesystem with a dual-panel layout — directory tree on the left, file list on the right
- Edit any text file directly in the terminal with syntax highlighting for 15+ languages
- Create, rename, delete, copy, and move files and directories
- Toggle hidden files on and off
- File info panel showing size, permissions, and timestamps
- Keyboard-driven — no mouse required

---

## Installation

### Linux (Debian / Ubuntu / Pop!_OS)

Download `shellman-1.0.0.deb` from the [Releases](https://github.com/Its-Atharva-Gupta/TUI-Based-File-Manager/releases) page, then:

```bash
sudo apt install ./shellman-1.0.0.deb
```

### Linux (Fedora / RHEL)

Download `shellman-1.0.0.rpm` from the [Releases](https://github.com/Its-Atharva-Gupta/TUI-Based-File-Manager/releases) page, then:

```bash
sudo dnf install ./shellman-1.0.0.rpm
```

### Linux (Arch)

Download the `shellman-linux` binary from the [Releases](https://github.com/Its-Atharva-Gupta/TUI-Based-File-Manager/releases) page, then:

```bash
sudo cp shellman-linux /usr/local/bin/shellman
sudo chmod +x /usr/local/bin/shellman
```

### macOS

Download the `shellman-macos` binary from the [Releases](https://github.com/Its-Atharva-Gupta/TUI-Based-File-Manager/releases) page, then:

```bash
sudo cp shellman-macos /usr/local/bin/shellman
sudo chmod +x /usr/local/bin/shellman
```

### Windows

Download `shellman-windows.exe` from the [Releases](https://github.com/Its-Atharva-Gupta/TUI-Based-File-Manager/releases) page. No installation needed — run it directly from a terminal:

```
shellman.exe
```

---

## Keyboard Shortcuts

| Key        | Action              |
|------------|---------------------|
| Enter      | Open directory      |
| Backspace  | Go up one directory |
| E          | Edit selected file  |
| N          | New file            |
| D          | New directory       |
| R          | Rename              |
| X          | Delete              |
| C          | Copy                |
| V          | Paste               |
| I          | File info           |
| H          | Toggle hidden files |
| F5         | Refresh             |
| Ctrl+L     | Go to path          |
| Ctrl+S     | Save file (in editor) |
| Esc        | Close editor        |
| Q          | Quit                |

---

## Run from Source

Requires Python 3.9 or later.

```bash
git clone https://github.com/Its-Atharva-Gupta/TUI-Based-File-Manager.git
cd TUI-Based-File-Manager
pip install textual
python src/file_manager.py
```

---

## Build from Source

If a prebuilt binary is not available for your platform or architecture, you can build one yourself. Requires Python 3.9+ and pip.

```bash
git clone https://github.com/Its-Atharva-Gupta/TUI-Based-File-Manager.git
cd TUI-Based-File-Manager
chmod +x scripts/build.sh
./scripts/build.sh
```

The script will automatically detect your operating system, install the required build tools, and produce a binary in the `dist/` folder.

---

## Dependencies

- [Textual](https://github.com/Textualize/textual) - TUI framework
- [Rich](https://github.com/Textualize/rich) - Terminal formatting (pulled in by Textual)

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## Author

Developed by [Its-Atharva-Gupta](https://github.com/Its-Atharva-Gupta).