#!/bin/bash
# +==============================================+
# |  gfetch installer                            |
# |  Deploys gfetch system info tool             |
# +==============================================+
set -euo pipefail

REPO="https://github.com/GlitchLinux/gfetch.git"
TARGET="/usr/local/bin/gfetch-data"
TMPDIR="/tmp/gfetch-install-$$"

C_OK="\033[1;32m"; C_INFO="\033[1;36m"; C_WARN="\033[1;33m"; C_ERR="\033[1;31m"; C_RST="\033[0m"
info()  { echo -e "${C_INFO}[*]${C_RST} $1"; }
ok()    { echo -e "${C_OK}[+]${C_RST} $1"; }
warn()  { echo -e "${C_WARN}[!]${C_RST} $1"; }
err()   { echo -e "${C_ERR}[x]${C_RST} $1"; }

# -- Must be root --
if [[ $EUID -ne 0 ]]; then
    err "This installer must run as root. Re-run with: sudo $0"
    exit 1
fi

# -- Dependency check --
info "Checking dependencies..."
MISSING=()
command -v git >/dev/null 2>&1 || MISSING+=("git")
command -v lolcat >/dev/null 2>&1 || [[ -x /usr/games/lolcat ]] || MISSING+=("lolcat")
if (( ${#MISSING[@]} > 0 )); then
    warn "Missing: ${MISSING[*]}"
    if command -v apt-get >/dev/null 2>&1; then
        info "Installing via apt..."
        apt-get update -qq && apt-get install -y "${MISSING[@]}"
    else
        err "Please install: ${MISSING[*]} and re-run."
        exit 1
    fi
fi
# borderize is optional (only needed if BORDERIZE_ENABLED=1)
if ! command -v borderize >/dev/null 2>&1; then
    warn "borderize not found - borderize feature unavailable until installed."
    warn "  Get it: https://github.com/GlitchLinux/BORDERIZE"
fi
ok "Dependencies satisfied."

# -- Fetch source --
# If run from inside a cloned repo (gfetch-data present next to this script), use that.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -d "${SCRIPT_DIR}/gfetch-data/gfetch-sysinfo-scripts" ]]; then
    info "Using local source: ${SCRIPT_DIR}/gfetch-data"
    SRC="${SCRIPT_DIR}/gfetch-data"
else
    info "Cloning ${REPO}..."
    rm -rf "$TMPDIR"
    git clone --depth 1 "$REPO" "$TMPDIR"
    SRC="${TMPDIR}/gfetch-data"
    if [[ ! -d "${SRC}/gfetch-sysinfo-scripts" ]]; then
        err "Cloned repo has unexpected layout (no gfetch-data/gfetch-sysinfo-scripts)."
        exit 1
    fi
fi

# -- Backup existing install --
if [[ -d "$TARGET" ]]; then
    BACKUP="${TARGET}.bak.$(date +%Y%m%d-%H%M%S)"
    warn "Existing install found - backing up to ${BACKUP}"
    mv "$TARGET" "$BACKUP"
fi

# -- Deploy --
info "Installing to ${TARGET}..."
mkdir -p "$TARGET"
cp -r "${SRC}/." "$TARGET/"

# -- Permissions --
chmod +x "${TARGET}/gfetch-sysinfo-scripts/"*.sh
chmod +x "${TARGET}/gfetch-controls/gfetch"
chmod +x "${TARGET}/gfetch-controls/gfetch-edit"

# -- Wrappers in PATH --
info "Creating launchers in /usr/local/bin..."
cat > /usr/local/bin/gfetch <<'EOF'
#!/bin/bash
bash /usr/local/bin/gfetch-data/gfetch-controls/gfetch "$@"
EOF
chmod +x /usr/local/bin/gfetch

cat > /usr/local/bin/gfetch-edit <<'EOF'
#!/bin/bash
bash /usr/local/bin/gfetch-data/gfetch-controls/gfetch-edit "$@"
EOF
chmod +x /usr/local/bin/gfetch-edit

# -- Sanity check ASCII path --
info "Verifying ASCII art path..."
AF=$(grep -E '^ASCII_FILE' "${TARGET}/gfetch-controls/gfetch-settings.conf" | cut -d'"' -f2)
if [[ ! -f "$AF" ]]; then
    warn "Configured ASCII_FILE missing ($AF) - resetting to default ascii-art-2"
    sed -i "s|^ASCII_FILE=.*|ASCII_FILE=\"${TARGET}/ASCII-ART/ascii-art-2\"|" "${TARGET}/gfetch-controls/gfetch-settings.conf"
fi

# -- Cleanup --
[[ -d "$TMPDIR" ]] && rm -rf "$TMPDIR"

ok "Installation complete."
echo ""
echo "  Run:        gfetch"
echo "  Configure:  gfetch-edit"
echo ""
