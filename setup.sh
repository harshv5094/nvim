#!/usr/bin/env bash

have() { command -v "$1" &>/dev/null; }

# Check if the script is running in the root
if [ "$(id -u)" -eq 0 ]; then
  echo "** Please don't run this script as root. **"
  exit 1
fi

# --- Variables --- #
REMOTE_URL="https://github.com/harshv5094/nvim"
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
CLONE_DIR="$XDG_CONFIG_HOME/nvim"

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
if [ ! -d "${REMOTE_URL}" ]; then
  echo "Clonning my neovim directory"
  git clone ${REMOTE_URL} "${CLONE_DIR}"
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

# --- Installing Dependencies --- #
case "$package_manager" in
pacman)
  $ESCALATION_TOOL pacman -S --needed --noconfirm base-devel git stylua shfmt lazygit
  ;;
apt)
  $ESCALATION_TOOL apt update && $ESCALATION_TOOL apt upgrade
  $ESCALATION_TOOL apt install -y build-essential git curl

  if ! have stylua; then
    curl -sL https://github.com/JohnnyMorganz/StyLua/releases/download/v0.24.0/stylua-linux-x86_64.zip -o /tmp/stylua.zip
    $ESCALATION_TOOL unzip -o /tmp/stylua.zip -d /usr/local/bin
    $ESCALATION_TOOL chmod +x /usr/local/bin/stylua
  fi

  if ! have shfmt; then
    $ESCALATION_TOOL apt install -y shfmt
  fi

  if ! have lazygit; then
    curl -sL https://github.com/jesseduffield/lazygit/releases/download/v0.45.0/lazygit_0.45.0_Linux_x86_64.tar.gz -o /tmp/lazygit.tar.gz
    $ESCALATION_TOOL tar -xzf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
    $ESCALATION_TOOL chmod +x /usr/local/bin/lazygit
  fi
  ;;
dnf)
  $ESCALATION_TOOL dnf groupinstall -y "Development Tools"
  $ESCALATION_TOOL dnf install -y git curl

  if ! have stylua; then
    curl -sL https://github.com/JohnnyMorganz/StyLua/releases/download/v0.24.0/stylua-linux-x86_64.zip -o /tmp/stylua.zip
    $ESCALATION_TOOL unzip -o /tmp/stylua.zip -d /usr/local/bin
    $ESCALATION_TOOL chmod +x /usr/local/bin/stylua
  fi

  if ! have shfmt; then
    curl -sL https://github.com/mvdan/sh/releases/download/v3.9.0/sh_v3.9.0_linux_amd64 -o /usr/local/bin/shfmt
    $ESCALATION_TOOL chmod +x /usr/local/bin/shfmt
  fi

  if ! have lazygit; then
    curl -sL https://github.com/jesseduffield/lazygit/releases/download/v0.45.0/lazygit_0.45.0_Linux_x86_64.tar.gz -o /tmp/lazygit.tar.gz
    $ESCALATION_TOOL tar -xzf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
    $ESCALATION_TOOL chmod +x /usr/local/bin/lazygit
  fi
  ;;
esac

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
