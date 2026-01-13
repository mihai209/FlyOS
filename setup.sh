#!/bin/bash

set -e

# ---------- helpers ----------
pause() {
  read -rp "Press Enter to continue..."
}

is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null
}

detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}

is_gaming_distro() {
  case "$1" in
    garuda|nobara|steamos|chimeraos|drauger)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

pkg_install() {
  case "$DISTRO" in
    ubuntu|debian|linuxmint|pop)
      sudo apt update
      sudo apt install -y "$@"
      ;;
    arch)
      sudo pacman -Sy --noconfirm "$@"
      ;;
    fedora)
      sudo dnf install -y "$@"
      ;;
    *)
      echo "Unsupported distro: $DISTRO"
      exit 1
      ;;
  esac
}

pkg_remove() {
  case "$DISTRO" in
    ubuntu|debian|linuxmint|pop)
      sudo apt remove -y "$@"
      ;;
    arch)
      sudo pacman -Rns --noconfirm "$@"
      ;;
    fedora)
      sudo dnf remove -y "$@"
      ;;
  esac
}

# ---------- environment checks ----------
if is_wsl; then
  echo "❌ WSL detected. Use real Linux."
  exit 1
fi

DISTRO=$(detect_distro)

if is_gaming_distro "$DISTRO"; then
  echo "❌ Gaming Linux distro detected ($DISTRO)."
  echo "This setup is intended for clean dev distros."
  exit 1
fi

# ---------- figlet ----------
if ! command -v figlet >/dev/null 2>&1; then
  echo "⚠ figlet not found."
  read -rp "Install figlet? (y/n): " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    pkg_install figlet
  else
    echo "figlet required. Exiting."
    exit 1
  fi
fi

clear
figlet FlyOS
echo "Bare-metal OS setup"
echo "Detected distro: $DISTRO"
echo

# ---------- menu ----------
while true; do
  echo "1) Install dependencies"
  echo "2) Remove installed languages"
  echo "0) Exit"
  echo
  read -rp "> " choice

  case "$choice" in
    1)
      clear
      figlet Install
      echo "Installing toolchain:"
      echo
      echo "pascal"
      echo "c"
      echo "make"
      echo "nasm"
      echo "qemu"
      echo

      case "$DISTRO" in
        ubuntu|debian|linuxmint|pop)
          pkg_install build-essential make nasm qemu-system fpc
          ;;
        arch)
          pkg_install base-devel make nasm qemu-system-x86 fpc
          ;;
        fedora)
          pkg_install @development-tools make nasm qemu-system-x86 fpc
          ;;
      esac

      echo
      echo "✅ Dependencies installed."
      pause
      clear
      ;;
    2)
      clear
      figlet Remove
      echo "Removing:"
      echo "pascal"
      echo "c toolchain"
      echo "make"
      echo "nasm"
      echo "qemu"
      echo

      read -rp "Are you sure? (y/n): " ans
      if [[ "$ans" =~ ^[Yy]$ ]]; then
        case "$DISTRO" in
          ubuntu|debian|linuxmint|pop)
            pkg_remove build-essential make nasm qemu-system fpc
            ;;
          arch)
            pkg_remove base-devel make nasm qemu-system-x86 fpc
            ;;
          fedora)
            pkg_remove make nasm qemu-system-x86 fpc
            ;;
        esac
        echo "🗑 Removed."
      else
        echo "Cancelled."
      fi
      pause
      clear
      ;;
    0)
      echo "Bye."
      exit 0
      ;;
    *)
      echo "Invalid option."
      pause
      clear
      ;;
  esac
done
