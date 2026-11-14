# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Flock (added by `flock install`)
if [ -d "/home/karlm/.local/share/flock/bin" ]; then export PATH="/home/karlm/.local/share/flock/bin":"/home/karlm/.local/share/flock/node-global/current/bin":"$PATH"; fi
. "$HOME/.cargo/env"
