#!/usr/bin/env bash
# =============================================================================
# Shellman - Universal Build Script
# Supports: Linux (Debian/Fedora/Arch), macOS, Windows (Git Bash / WSL)
# =============================================================================

set -e  # exit on any error

APP_NAME="shellman"
SRC_FILE="src/file_manager.py"
VERSION="1.0.0"

# ─────────────────────────── Colors ───────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}[OK]${NC}    $1"; }
warning() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─────────────────────────── Detect OS ───────────────────────────
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            OS="debian"
        elif [ -f /etc/fedora-release ]; then
            OS="fedora"
        elif [ -f /etc/arch-release ]; then
            OS="arch"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    info "Detected OS: $OS"
}

# ─────────────────────────── Check Python ───────────────────────────
check_python() {
    info "Checking for Python..."

    if command -v python3 &>/dev/null; then
        PYTHON="python3"
    elif command -v python &>/dev/null; then
        PYTHON="python"
    else
        error "Python not found. Please install Python 3.9 or later from https://python.org"
    fi

    # Check version is 3.9+
    PY_VERSION=$($PYTHON -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    PY_MAJOR=$($PYTHON -c "import sys; print(sys.version_info.major)")
    PY_MINOR=$($PYTHON -c "import sys; print(sys.version_info.minor)")

    if [[ "$PY_MAJOR" -lt 3 || ("$PY_MAJOR" -eq 3 && "$PY_MINOR" -lt 9) ]]; then
        error "Python 3.9+ required. You have $PY_VERSION. Please upgrade."
    fi

    success "Found Python $PY_VERSION"
}

# ─────────────────────────── Check pip ───────────────────────────
check_pip() {
    info "Checking for pip..."
    if ! $PYTHON -m pip --version &>/dev/null; then
        warning "pip not found. Attempting to install..."
        case $OS in
            debian)  sudo apt install -y python3-pip ;;
            fedora)  sudo dnf install -y python3-pip ;;
            arch)    sudo pacman -S --noconfirm python-pip ;;
            macos)   $PYTHON -m ensurepip --upgrade ;;
            *)       error "pip not found. Install it manually: https://pip.pypa.io" ;;
        esac
    fi
    success "pip is available"
}

# ─────────────────────────── Install PyInstaller & Textual ───────────────────────────
install_deps() {
    info "Installing PyInstaller and Textual..."
    $PYTHON -m pip install --quiet --upgrade pyinstaller textual
    success "Dependencies installed"
}

# ─────────────────────────── Build Binary ───────────────────────────
build_binary() {
    info "Building binary with PyInstaller..."

    if [ ! -f "$SRC_FILE" ]; then
        error "Source file '$SRC_FILE' not found. Run this script from the project root."
    fi

    pyinstaller \
        --onefile \
        --collect-all rich \
        --collect-all textual \
        --name "$APP_NAME" \
        "$SRC_FILE"

    success "Binary built at dist/$APP_NAME"
}

# ─────────────────────────── Package for each OS ───────────────────────────
package_debian() {
    info "Packaging as .deb..."
    mkdir -p shellman-deb/DEBIAN
    mkdir -p shellman-deb/usr/local/bin
    cp dist/$APP_NAME shellman-deb/usr/local/bin/
    chmod 755 shellman-deb/usr/local/bin/$APP_NAME
    cat > shellman-deb/DEBIAN/control << EOF
Package: $APP_NAME
Version: $VERSION
Architecture: amd64
Maintainer: Its-Atharva-Gupta <itsatharva.gupta@gmail.com>
Description: A user friendly Terminal based file manager and editor.
EOF
    chmod 755 shellman-deb/DEBIAN
    dpkg-deb --build shellman-deb ${APP_NAME}-${VERSION}.deb
    rm -rf shellman-deb
    success "Created ${APP_NAME}-${VERSION}.deb"
}

package_fedora() {
    info "Packaging as .rpm..."
    mkdir -p ~/rpmbuild/{SPECS,SOURCES,BUILD,RPMS,SRPMS}
    cp dist/$APP_NAME ~/rpmbuild/SOURCES/
    cat > ~/rpmbuild/SPECS/$APP_NAME.spec << EOF
Name:       $APP_NAME
Version:    $VERSION
Release:    1%{?dist}
Summary:    A user friendly Terminal based file manager and editor
License:    MIT

%description
A user friendly Terminal based file manager and editor built with Textual.

%install
mkdir -p %{buildroot}/usr/local/bin
cp %{_sourcedir}/$APP_NAME %{buildroot}/usr/local/bin/$APP_NAME
chmod 755 %{buildroot}/usr/local/bin/$APP_NAME

%files
/usr/local/bin/$APP_NAME
EOF
    rpmbuild -bb ~/rpmbuild/SPECS/$APP_NAME.spec
    find ~/rpmbuild/RPMS -name "*.rpm" -exec cp {} . \;
    success "Created .rpm package"
}

package_arch() {
    info "Note: For Arch, the binary at dist/$APP_NAME is ready to use."
    info "Copy it to /usr/local/bin/ manually:"
    echo ""
    echo "    sudo cp dist/$APP_NAME /usr/local/bin/$APP_NAME"
    echo "    sudo chmod +x /usr/local/bin/$APP_NAME"
    echo ""
}

package_macos() {
    info "Note: macOS binary is at dist/$APP_NAME"
    info "To install system-wide:"
    echo ""
    echo "    sudo cp dist/$APP_NAME /usr/local/bin/$APP_NAME"
    echo "    sudo chmod +x /usr/local/bin/$APP_NAME"
    echo ""
}

package_windows() {
    info "Windows .exe is at dist/${APP_NAME}.exe — no further packaging needed."
}

# ─────────────────────────── Main ───────────────────────────
echo ""
echo "======================================"
echo "   Shellman v$VERSION — Build Script  "
echo "======================================"
echo ""

detect_os
check_python
check_pip
install_deps
build_binary

case $OS in
    debian)  package_debian ;;
    fedora)  package_fedora ;;
    arch)    package_arch ;;
    macos)   package_macos ;;
    windows) package_windows ;;
    *)
        warning "Unknown OS — binary is at dist/$APP_NAME, package it manually."
        ;;
esac

echo ""
success "Build complete!"