#!/bin/bash
if command -v conda &> /dev/null; then
    echo "conda is currently running. Attempting to deactivate..."
    conda deactivate
    if [ -n "$CONDA_SHLVL" ] && [ "$CONDA_SHLVL" -gt "0" ]; then
        echo "Trying to exit from base environment..."
        conda deactivate
    fi
fi
# Cancel auto init for Anaconda
conda config --set auto_activate_base false
# Install necessary dependencies (for Ubuntu/Debian)

if sudo -n true 2>/dev/null; then
    SUDO='sudo'
else
    SUDO=''
fi

# List of packages to be installed
PACKAGES="make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git"

# Execute package update and installation command
$SUDO apt-get update
$SUDO apt-get install -y $PACKAGES

# Install pyenv
if [ ! -d "${HOME}/.pyenv" ]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
else
    echo "pyenv is already installed"
fi
# Check and add environment variable settings
BASHRC=~/.bashrc
PYENV_ROOT='export PYENV_ROOT="$HOME/.pyenv"'
PATH_UPDATE='export PATH="$PYENV_ROOT/bin:$PATH:~/.local/bin"'
INIT_COMMAND='eval "$(pyenv init --path)"'
#VIRTUALENV_INIT='eval "$(pyenv virtualenv-init -)"'
# Add PYENV_ROOT
if ! grep -Fxq "$PYENV_ROOT" $BASHRC; then
    echo $PYENV_ROOT >> $BASHRC
fi
# Add PATH update
if ! grep -Fxq "$PATH_UPDATE" $BASHRC; then
    echo $PATH_UPDATE >> $BASHRC
fi
# Add pyenv init
if ! grep -Fxq "$INIT_COMMAND" $BASHRC; then
    echo $INIT_COMMAND >> $BASHRC
fi
# Add pyenv virtualenv-init
if ! grep -Fxq "$VIRTUALENV_INIT" $BASHRC; then
    echo $VIRTUALENV_INIT >> $BASHRC
fi
echo "pyenv setup is completed. Please restart your shell or run 'source ~/.bashrc'"