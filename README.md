# gfetch

A fast, modular system-information tool with lolcat-colored ASCII art, built for Debian-based systems. Companion to `bfetch`.

![shell](https://img.shields.io/badge/shell-bash-green)

## Features

- 150+ modular sysinfo scripts - enable only what you want
- lolcat-colored ASCII art with multiple built-in art files
- Side-by-side ASCII + system info layout with auto-centering
- Optional `borderize` framing
- Interactive configuration via `gfetch-edit`

## Install

```bash
git clone https://github.com/GlitchLinux/gfetch.git
cd gfetch
sudo ./install.sh
```

The installer:

1. Checks dependencies (`git`, `lolcat`; `borderize` optional)
2. Backs up any existing install at `/usr/local/bin/gfetch-data`
3. Deploys files to `/usr/local/bin/gfetch-data`
4. Creates `gfetch` and `gfetch-edit` launchers in `/usr/local/bin`
5. Verifies the ASCII art path resolves

## Usage

```bash
gfetch         # print system info
gfetch-edit    # interactive config menu
```

## Configuration

`gfetch-edit` provides a menu to:

- Edit which sysinfo modules are shown (`gfetch.cfg`)
- Edit display settings (`gfetch-settings.conf`)
- Toggle and color the `borderize` frame
- Set custom ASCII art (path + row count)
- Reset ASCII art to the default
- Preview the result

## Layout

```
gfetch-data/
├── ASCII-ART/             # ASCII art files
├── gfetch-controls/       # gfetch, gfetch-edit, configs
│   ├── gfetch             # main render script
│   ├── gfetch-edit        # interactive config editor
│   ├── gfetch.cfg         # active module selection
│   ├── gfetch-ALL.cfg     # reference: all modules
│   └── gfetch-settings.conf
└── gfetch-sysinfo-scripts/  # numbered module scripts
```

## Adding modules

Drop a numbered script (e.g. `200-mything.sh`) into `gfetch-sysinfo-scripts/`, make it executable, then reference it in `gfetch.cfg`. Each module prints a single info line.

## Dependencies

- `bash`
- `lolcat` (for colored ASCII)
- `borderize` (optional) - https://github.com/GlitchLinux/BORDERIZE

## License

See repository.
