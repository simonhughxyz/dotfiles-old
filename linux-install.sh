#!/bin/sh
#
# NAME: linux-install.sh
# AUTHOR: Simon H Moore <simon@simonhugh.xyz>
# DATE: 22 October 2023
# DESC: Install config files for linux systems

#NOTE: Not complete! Don't use!

export DOTFILES_HTTP="https://github.com/simonhughxyz/dotfiles"
export DOTFILES_SSH="git@github.com:simonhughxyz/dotfiles.git"
export DOTFILES_DIR="$HOME/Projects/dotfiles"

dependancy_check() {
  if [ ! "$(command -v "$1")" ]; then
    echo "Missing dependency: $1" &
    exit 1
  fi
}

dependancy_check "git"

yesno_question() {
  while true; do
    printf "%s [Y/N]: " "$1"
    read -r yn
    case $yn in
    [Yy]*)
      return 0
      ;;
    [Nn]*)
      return 1
      ;;
    *) echo "Please answer yes or no." ;;
    esac
  done
}

# check if dotfiles exist and is git repo with correct origin
if [ -d "${DOTFILES_DIR}/.git" ]; then
  git_url="$(git --git-dir "${DOTFILES_DIR}/.git" config --get remote.origin.url)"
  if [ "$git_url" = "$DOTFILES_HTTP" ] || [ "$git_url" = "$DOTFILES_SSH" ]; then
    export DOTFILES_ORIGIN="$git_url"
    echo "Found existing dotfiles directory in ${DOTFILES_DIR}"
    if yesno_question "Do you want to pull the latest commits?"; then
      git --git-dir "${DOTFILES_DIR}/.git" pull >/dev/null 2>/dev/null
    fi
  fi
fi

if [ -z "${DOTFILES_ORIGIN}" ]; then
  if [ -d "$DOTFILES_DIR" ]; then
    if yesno_question "Do you want to remove the existing dotfiles directory?"; then
      echo "Removing ${DOTFILES_DIR}..."
      rm -rf "$DOTFILES_DIR"
    fi
  fi
  if [ ! -d "$DOTFILES_DIR" ]; then
    if yesno_question "Do you want to clone the dotfiles directory?"; then
      if git clone "$DOTFILES_SSH" "$DOTFILES_DIR"; then
        echo "SSH clone successful"
      else
        echo "SSH clone failed, attempting http clone..."
        if git clone "$DOTFILES_HTTP" "$DOTFILES_DIR"; then
          echo "HTTP clone successful"
        else
          echo "Git clone failed, aborting!"
          exit 1
        fi
      fi
    fi
  fi
fi

dir="$(find . -mindepth 1 -maxdepth 1 -not -path '*/.*' -type d -printf "%p\n")"
echo "$dir"
