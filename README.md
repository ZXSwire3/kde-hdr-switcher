# hdr-switcher

`hdr-switcher` is a small KDE Plasma utility for quickly switching HDR on and off from either:
- a panel launcher (right-click actions), or
- a persistent tray icon in the status notifier area.

It is built around KDE's `kscreen-doctor`, so it uses Plasma's native display control path.

## Features

- Enable, disable, or toggle HDR on all connected + enabled HDR-capable outputs.
- Optional status notifications with custom HDR on/off icons.
- Automatic brightness handling when HDR is off (default: `100%`).
- Optional brightness setting when HDR is on (disabled by default; configure in settings).
- Optional Night Light suspension when HDR is on (disabled by default; configure in settings or via `--suspend-night-light`).
- Tray settings menu to configure HDR-off and HDR-on brightness, Night Light suspension, and persist them.
- User-local install (`~/.local`), no root required.

## Requirements

- KDE Plasma on Wayland with HDR-capable display support.
- `kscreen-doctor` in `PATH`.
- `python3`.
- `notify-send` for desktop notifications (optional).
- For tray mode:
  - Python GObject bindings (`gi` / `PyGObject`)
  - GTK 3
  - AppIndicator3/Ayatana AppIndicator3

## Build And Install

This project is script-based (no compile/build system). "Build" is just installing scripts and desktop entries.

1. Clone and enter the repo:

```bash
git clone <repo-url>
cd hdr-switcher
```

2. Install locally:

```bash
./install.sh
```

This installs:
- `~/.local/bin/hdr-switcher`
- `~/.local/bin/hdr-switcher-tray`
- `~/.local/share/applications/hdr-switcher.desktop`
- `~/.local/share/applications/hdr-switcher-tray.desktop`
- `~/.local/share/hdr-switcher/images/hdr-on.png`
- `~/.local/share/hdr-switcher/images/hdr-off.png`

If `~/.local/bin` is not in your shell `PATH`, run commands with full paths (for example `~/.local/bin/hdr-switcher`).

3. Optional sanity check:

```bash
python3 -m py_compile bin/hdr-switcher bin/hdr-switcher-tray
```

## Usage

### CLI

```bash
hdr-switcher on
hdr-switcher off
hdr-switcher toggle
hdr-switcher status
hdr-switcher list
```

Common flags:

```bash
hdr-switcher off --off-brightness 85
hdr-switcher on --on-brightness 80
hdr-switcher toggle --no-off-brightness
hdr-switcher toggle --no-on-brightness
hdr-switcher on --suspend-night-light
hdr-switcher off --no-suspend-night-light
hdr-switcher status --no-notify
```

### Panel Launcher Mode

1. Open KDE Application Launcher.
2. Search for `HDR Switcher`.
3. Right-click and choose `Pin to Task Manager` (or `Add to Panel`).
4. Right-click the panel icon to use actions:
   - `Enable HDR`
   - `Disable HDR`
   - `Toggle HDR`
   - `Show HDR Status`

### Tray Mode (Right-Side System Tray Area)

Run:

```bash
hdr-switcher-tray
```

Right-click the tray icon for:
- `Enable HDR`
- `Disable HDR`
- `Toggle HDR`
- `Settings`
- `Refresh Status`

Tray settings include preset brightness values and `Set Custom...` for both HDR-off and HDR-on brightness.

## Configuration

Settings are stored in:

`~/.config/hdr-switcher/config.json`

Current keys:

```json
{
  "off_brightness": 100,
  "on_brightness": 80,
  "suspend_night_light": false
}
```

Behavior:
- `off_brightness` is used when HDR is switched off (via `off` or `toggle` landing in off).
- `on_brightness` is used when HDR is switched on (via `on` or `toggle` landing in on). Omitting this key (or setting it to `null`) disables the feature — brightness is left unchanged when HDR is turned on.
- `suspend_night_light` controls whether KDE Night Light is inhibited while HDR is on and resumed when HDR is off. Defaults to `false`. When enabled, Night Light is inhibited (via its DBus interface) each time HDR turns on, and uninhibited each time HDR turns off.
- CLI `--off-brightness` / `--on-brightness` override the respective config values for that command invocation.
- CLI `--no-off-brightness` / `--no-on-brightness` skip brightness adjustment for that invocation regardless of config.
- CLI `--suspend-night-light` / `--no-suspend-night-light` override the `suspend_night_light` config value for that invocation.

## Autostart Tray On Login

```bash
mkdir -p ~/.config/autostart
cp ~/.local/share/applications/hdr-switcher-tray.desktop ~/.config/autostart/
```

## Troubleshooting

- `HDR Switcher` not shown in launcher:

```bash
kbuildsycoca6 --noincremental
```

- Tray icon hidden:
  - System Tray settings -> Entries -> set `HDR Switcher Tray` to `Always shown`.

- `kscreen-doctor` not found:
  - Install KDE display tooling for your distro and verify:

```bash
command -v kscreen-doctor
```

- Brightness did not change on HDR off:
  - Your output may not expose brightness control via KDE/kscreen.

## Uninstall

```bash
rm -f ~/.local/bin/hdr-switcher
rm -f ~/.local/bin/hdr-switcher-tray
rm -f ~/.local/share/applications/hdr-switcher.desktop
rm -f ~/.local/share/applications/hdr-switcher-tray.desktop
rm -rf ~/.local/share/hdr-switcher
rm -rf ~/.config/hdr-switcher
```

## Notes

- Exit code `2` means no active HDR-capable output was found.
- This tool targets KDE Plasma behavior; other desktop environments are not supported.
