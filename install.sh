#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/applications"
ICON_DIR="${HOME}/.local/share/hdr-switcher/images"
TARGET_BIN="${LOCAL_BIN}/hdr-switcher"
TARGET_TRAY_BIN="${LOCAL_BIN}/hdr-switcher-tray"
TARGET_DESKTOP="${APP_DIR}/hdr-switcher.desktop"
TARGET_TRAY_DESKTOP="${APP_DIR}/hdr-switcher-tray.desktop"
TARGET_ICON_ON="${ICON_DIR}/hdr-on.png"
TARGET_ICON_OFF="${ICON_DIR}/hdr-off.png"

mkdir -p "${LOCAL_BIN}" "${APP_DIR}" "${ICON_DIR}"

install -m 0755 "${SCRIPT_DIR}/bin/hdr-switcher" "${TARGET_BIN}"
install -m 0755 "${SCRIPT_DIR}/bin/hdr-switcher-tray" "${TARGET_TRAY_BIN}"
install -m 0644 "${SCRIPT_DIR}/images/hdr-on.png" "${TARGET_ICON_ON}"
install -m 0644 "${SCRIPT_DIR}/images/hdr-off.png" "${TARGET_ICON_OFF}"

escaped_bin_path="$(printf '%s' "${TARGET_BIN}" | sed 's/[\\/&]/\\&/g')"
escaped_tray_bin_path="$(printf '%s' "${TARGET_TRAY_BIN}" | sed 's/[\\/&]/\\&/g')"
escaped_icon_on="$(printf '%s' "${TARGET_ICON_ON}" | sed 's/[\\/&]/\\&/g')"
escaped_icon_off="$(printf '%s' "${TARGET_ICON_OFF}" | sed 's/[\\/&]/\\&/g')"
sed -e "s/@HDR_SWITCHER_PATH@/${escaped_bin_path}/g" \
    -e "s/@HDR_ON_ICON@/${escaped_icon_on}/g" \
    -e "s/@HDR_OFF_ICON@/${escaped_icon_off}/g" \
    "${SCRIPT_DIR}/hdr-switcher.desktop.in" > "${TARGET_DESKTOP}"
sed -e "s/@HDR_SWITCHER_TRAY_PATH@/${escaped_tray_bin_path}/g" \
    -e "s/@HDR_OFF_ICON@/${escaped_icon_off}/g" \
    "${SCRIPT_DIR}/hdr-switcher-tray.desktop.in" > "${TARGET_TRAY_DESKTOP}"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "${APP_DIR}" >/dev/null 2>&1 || true
fi

cat <<EOF
Installed:
  Script:  ${TARGET_BIN}
  Tray:    ${TARGET_TRAY_BIN}
  Launcher: ${TARGET_DESKTOP}
  Tray app: ${TARGET_TRAY_DESKTOP}
  Icons:   ${ICON_DIR}

Next steps in KDE:
1. Open Application Launcher, search for "HDR Switcher".
2. Right-click it and choose "Pin to Task Manager" (or "Add to Panel").
3. Right-click the panel icon to use: Enable HDR, Disable HDR, Toggle HDR, Show HDR Status.
4. For a right-side tray icon, launch "HDR Switcher Tray".
EOF
