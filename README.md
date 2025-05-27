# Dotfiles

<p align="center">
  <img src="assets/showcase.png" alt="Desktop Screenshot" />
</p>

<p align="center">
  <em>Personal configuration files for a customized Linux desktop environment</em>
</p>

---

## 📋 Table of Contents
- [Dotfiles](#dotfiles)
  - [📋 Table of Contents](#-table-of-contents)
  - [🤔 What is dotfile?](#-what-is-dotfile)
  - [📁 Content](#-content)
    - [Folders](#folders)
    - [Applications](#applications)
  - [📦 Requirements](#-requirements)
    - [Optional Dependencies](#optional-dependencies)
  - [🚀 Installation](#-installation)
  - [🎯 Usage](#-usage)
    - [Key Features](#key-features)
  - [📄 License](#-license)

## 🤔 What is dotfile?

A dotfile is a hidden configuration file that starts with a dot (.) and is used to store settings for applications and tools. They are commonly found in the home directory and allow you to customize your system's behavior and appearance.

## 📁 Content

### Folders
- **`.fonts`** - Custom fonts
- **`.config`** - Application configurations  
- **`.themes`** - GTK themes
- **`.poshthemes`** - PowerShell themes

### Applications
- **Sway** - Wayland compositor
- **Waybar** - Status bar for Wayland
- **Alacritty** - Terminal emulator
- **Ghostty** - Terminal emulator
- **Fish** - Friendly interactive shell
- **Neovim** - Text editor
- **Kanata** - Key remapping
- **Btop** - System monitor
- **Systemd** - System services

## 📦 Requirements

Ensure you have the following dependencies installed on your system:

| Package                    | Description                       | Installation Command                                                             |
| -------------------------- | --------------------------------- | -------------------------------------------------------------------------------- |
| **Git**                    | Version control system            | `sudo apt install git`                                                           |
| **Stow**                   | Symlink farm manager              | `sudo apt install stow`                                                          |
| **Sway**                   | Wayland compositor                | `sudo apt install sway`                                                          |
| **Waybar**                 | Status bar                        | `sudo apt install waybar`                                                        |
| **Alacritty**              | Terminal emulator                 | `sudo apt install alacritty`                                                     |
| **Fish**                   | Shell                             | `sudo apt install fish`                                                          |
| **Neovim**                 | Text editor                       | `sudo apt install neovim`                                                        |
| **xdg-desktop-portal-wlr** | Desktop portal for screen sharing | [Build manually from GitHub](https://github.com/emersion/xdg-desktop-portal-wlr) |

### Optional Dependencies
| Package     | Description          | Installation Command                                           |
| ----------- | -------------------- | -------------------------------------------------------------- |
| **Ghostty** | Alternative terminal | [Download from GitHub](https://github.com/ghostty-org/ghostty) |
| **Btop**    | System monitor       | `sudo apt install btop`                                        |
| **Wofi**    | Application launcher | `sudo apt install wofi`                                        |
| **Mako**    | Notification daemon  | `sudo apt install mako-notifier`                               |
| **Fusuma**  | Touchpad gestures    | `sudo gem install fusuma`                                      |

## 🚀 Installation

1. **Clone the repository** to your home directory:
   ```fish
   git clone git@github.com:insanansharyrasul/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Create symlinks** using GNU Stow:
   ```fish
   stow .
   ```

3. **Reload your configuration** or restart your session to apply changes.

## 🎯 Usage

After installation, your dotfiles will be symlinked to their appropriate locations. You can:

- **Update configurations** by editing files in the `~/.dotfiles` directory
- **Add new configs** by placing them in the appropriate folder structure
- **Sync changes** by running `git pull` in the dotfiles directory

### Key Features
- 🎨 **Ayu Dark theme** across all applications
- ⚡ **Optimized Sway configuration** with custom keybindings
- 🔧 **Custom Waybar** with network menu and system monitoring
- 📝 **Configured terminals** (Alacritty & Ghostty) with matching themes
- 🎛️ **Dynamic gap adjustment** shortcuts for Sway

## 📄 License

This project is licensed under the GPL-3.0 license - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <em>Happy customizing! 🏠✨</em>
</p>
