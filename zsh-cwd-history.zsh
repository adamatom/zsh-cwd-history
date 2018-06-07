#!/usr/bin/env zsh

# zsh_cwd_history
# Copyright (c) 2018 Adam Labbe
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

_zsh_cwd_history_file="$HOME/.directory_history/${PWD:A}/history"

function _zsh-cwd-history-change-cwd() {
    _zsh_cwd_history_file="$HOME/.directory_history/${PWD:A}/history"
    [[ -d ${_zsh_cwd_history_file:h} ]] || mkdir -p ${_zsh_cwd_history_file:h}

    # Wipe history to start. Pop any previous frame and start a new frame for a new history list.
    fc -P; fc -p "$HISTFILE"

    # Ensure there is history for this cwd before we attempt to append it.
    [[ -e $_zsh_cwd_history_file ]] || return

    # Dont allow the cwd history to grow unbounded
    if [ $(wc -l < $_zsh_cwd_history_file) -gt $SAVEHIST ]; then
        tail -n $SAVEHIST $_zsh_cwd_history_file > $_zsh_cwd_history_file
    fi

    # Load in the cwd history next. Dir history will take priority because they are loaded
    # deeper in the cwd list.
    fc -R $_zsh_cwd_history_file
}

function _zsh-cwd-history-addhistory() {
    # capture what will be logged in the global history file and also write it to our
    # cwd-specific history file. ZSH will maintain it's global history file, and we will try
    # to duplicate behavior and maintain the local history manually.
    local entry=""
    [[ -o extended_history ]] && entry=": $(date +%s):0;"
    echo "$entry${1%%$'\n'}" >> $_zsh_cwd_history_file
}

#add hooks, chpwd for reloading that dir's history, and zshaddhistory for recording to local history
function _zsh-cwd-history-initialize() {
    # remove precmd hook, it was used for the one-off loading
    add-zsh-hook -d precmd _zsh-cwd-history-initialize

    # setup for the initial cwd
    _zsh-cwd-history-change-cwd
    add-zsh-hook chpwd _zsh-cwd-history-change-cwd
    add-zsh-hook zshaddhistory _zsh-cwd-history-addhistory
}

autoload -U add-zsh-hook
add-zsh-hook precmd _zsh-cwd-history-initialize
