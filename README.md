ZSH-CWD-History
=========================

Yet another implementation of a directory-aware history that works well with [ZSH autocomplete][1].

Design contraints:
* No external scripts or utilities
* Each directory maintained within its own history file
* Directory specific history first, with global fallback
* Full history maintained by ZSH
* Compatiable with [zsh-history-substring-search][2]

## Installation

### Manual
1. Clone this repository to place such as `~/.zsh/zsh-cwd-history`

    ```v
    git clone https://github.com/adamatom/zsh-cwd-history ~/.zsh/zsh-cwd-history
    ```

2. Add the following to your `.zshrc`:

    ```sh
    source ~/.zsh/zsh-cwd-history/zsh-cwd-history.zsh
    ```


### Antibody
1. Add `adamatom/zsh-cwd-history` to your antibody_plugins.txt:

    ```sh
    echo "adamatom/zsh-cwd-history" >> ~/.zsh/antibody_plugins.txt
    ```
2. Make sure to source antibody in your `.zshrc`:

    ```sh
    antibody bundle < ~/.zsh/antibody_plugins.txt  > ~/.zsh/antibody_sourceables.zsh
    antibody update
    ```


[1]: https://github.com/zsh-users/zsh-autosuggestions
[2]: https://github.com/zsh-users/zsh-history-substring-search
