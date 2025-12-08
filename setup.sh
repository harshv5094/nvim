#!/usr/bin/env bash

have() { command -v "$1" &>/dev/null; }

# Check if the script is running in the root
if [ "$(id -u)" -eq 0 ]; then
  echo "** Please don't run this script as root. **"
  exit 1
fi

# --- Variables --- #
CLONE_DIR="https://github.com/harshv5094/nvim"
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# Detect escalation tool (sudo, doas, or none if root)
if [ "$(id -u)" -eq 0 ]; then
  ESCALATION_TOOL="" # already root
elif have sudo; then
  ESCALATION_TOOL="sudo"
elif have doas; then
  ESCALATION_TOOL="doas"
else
  echo "No privilege escalation tool (sudo/doas) found and not running as root."
  exit 1
fi

# --- Clonning my directories --- #
if [ ! -d "${CLONE_DIR}" ]; then
  echo "Clonning my neovim directory"
  git clone ${CLONE_DIR} ${XDG_CONFIG_HOME}/nvim
fi

# --- Package Manager Detection --- #
if have pacman; then
  package_manager="pacman"
elif have apt; then
  package_manager="apt"
elif have dnf; then
  package_manager="dnf"
else
  echo "No supported package manager found (pacman, apt, dnf). Exiting."
  exit 1
fi

# --- Installing Neovim --- #
case "$package_manager" in
pacman)
  $ESCALATION_TOOL pacman -S --needed --noconfirm nvim
  ;;
apt)
  $ESCALATION_TOOL apt update && $ESCALATION_TOOL apt upgrade
  $ESCALATION_TOOL apt install -y nvim
  ;;
dnf)
  $ESCALATION_TOOL dnf install -y nvim
  ;;
esac
