

# ageldama/configs

A curated collection of personal dotfiles, system configurations, and utility scripts for Linux, FreeBSD, and macOS environments. This repository consolidates developer toolchains, desktop window manager tweaks, shell environments, and system administration helpers.

## 📂 Repository Structure

| Directory | Description |
|-----------|-------------|
| `apps/` | Application-specific configurations and scripts |
| `apps/emacs-old/` | Legacy Emacs setups, compile command parsers, ESLint & JS project configs |
| `apps/debian/` | Package management utilities (e.g., installed package size checker) |
| `apps/misc/` | General utilities: backups, audio routing, Bluetooth, system tweaks, tmux/Kafka sessions |
| `apps/koreader/`, `qutebrowser-config.py` | Custom reader & browser settings |
| `dotfiles/` | Core environment configurations |
| `dotfiles/HOME-icewm/` | IceWM window manager themes, patch files, and helper scripts |
| `dotfiles/local_bin/` | Custom CLI tools and scripts (Shell, Python, PHP, C) |
| `mods/` | Bundled third-party libraries (e.g., `uthash` C macros) |

## 🛠️ Installation & Setup

This repository functions as a dotfiles archive. `apps/misc/install.sh` is provided as a **reference guide**, not an executable installer. To apply these configurations:

### 1. Clone the Repository
```bash
git clone https://github.com/ageldama/configs.git ~/.local/configs
```

### 2. Core Environment Setup
Follow the steps outlined in `apps/misc/install.sh` and adapt them to your OS:
- **Shell**: Install `zsh`, `oh-my-zsh`, and `autoenv`. Copy `zshrc.local` and source it in your `~/.zshrc`.
- **Terminal Multiplexer**: `cp dotfiles/tmux.conf ~/.tmux.conf`
- **Editors**:
  - **Vim**: Clone Vundle (`~/.vim/bundle/vundle`) and run `vim +VundleInstall`
  - **Emacs**: Copy `init.el` and `init2.el` to `~/.emacs.d/`, then clone `use-package` into the directory
- **Desktop/WM**: Place IceWM themes in `~/.icewm/themes/` and apply X11 tweaks (e.g., `xmodmap`, touchpad toggling)

### 3. Add Custom Binaries to PATH
Scripts in `dotfiles/local_bin/` can be symlinked or added to your shell profile:
```bash
export PATH="$HOME/.local/configs/dotfiles/local_bin:$PATH"
```

## 💻 Usage & Scripts

### Compile Commands & Tag Generation
`apps/misc/compile_commands_json_incdirs.py` parses `compile_commands.json` to extract compiler flags and include directories. It can automatically generate `ctags` or `etags` databases for IDE navigation:
```bash
python3 compile_commands_json_incdirs.py --ctags
python3 compile_commands_json_incdirs.py --system --print  # Include system headers & print paths
```

### Rofi Yes/No Dialogs
`dotfiles/local_bin/+archive+/yesno.{py,php,c}` provide cross-language implementations of system confirmation dialogs using `rofi`:
```bash
./yesno.py "Proceed with operation?"
# Exits 0 for Yes, -1 for No
```

### System & Network Utilities
- `pa-in2out.sh`: Routes PulseAudio input directly to output (useful for testing or loopback)
- `conn-bluetooth-speaker.sh`: Quick Bluetooth controller script (replace `XXXXX` with your device MAC)
- `run-local-zk-kfk.sh`: Spins up a local Zookeeper & Kafka session in `tmux`
- `find-pkgconfig.sh`: Scans directories to export a valid `PKG_CONFIG_PATH`

## 📝 Notes
- Scripts are primarily tested on Debian/Ubuntu, FreeBSD, and macOS. Adjust package managers (`apt`, `dnf`, `yaourt`, `pkg`) and paths accordingly.
- The `apps/emacs-old/` directory contains experimental parsers and legacy configurations.
- For theme conversions (`dotfiles/HOME-icewm/.../convert.sh`), `ImageMagick` (`convert`, `composite`) is required.
- Contributions, platform-specific forks, or script improvements are welcome.
