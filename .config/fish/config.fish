# ~/.config/fish/config.fish

# --- Set Vi-style keybindings ---
fish_vi_key_bindings

# --- Custom VI Mode Indicator ---
# This function is automatically called by fish to show your current mode.
# We'll color it to match your Gruvbox theme.
function fish_mode_prompt
    switch $fish_key_mode
        case default
            # Normal Mode (Gruvbox Orange)
            set_color -o fe8019
            echo '[N]'
        case insert
            # Insert Mode (Gruvbox Green)
            set_color -o b8bb26
            echo '[I]'
        case visual
            # Visual Mode (Gruvbox Purple)
            set_color -o d3869b
            echo '[V]'
    end
    # Reset to normal color
    set_color normal
    echo ' '
end

# Set PATH (Fish usually handles this well by inheriting, but you can add more)
# Ensure $HOME/.local/bin is in PATH if you install binaries there
if not string match -q -- "*$HOME/.local/bin*" "$PATH"
    set -gx PATH "$HOME/.local/bin" $PATH
end

# --- Set the default editor ---
# Use 'vim' for both the full-screen (VISUAL) and line (EDITOR) editor.
set -x VISUAL vim
set -x EDITOR vim

alias cat "bat"
# --- eza Aliases (Modern replacement for ls) ---
# Ensure eza is installed: `sudo pacman -S eza`
# (or `cargo install eza` if you prefer building from source)
if type -q eza
    alias ls "eza -l -a -h --icons --color=auto --group-directories-first --git --header"

    alias la "eza -l -a --icons --color=auto --group-directories-first --git --header"

    alias tree "eza -T --icons --color=auto --group-directories-first"
    alias tree2 "eza -T -L 2 --icons --color=auto --group-directories-first"
    alias tree3 "eza -T -L 3 --icons --color=auto --group-directories-first"
else
    # Fallback to standard ls if eza is not found
    alias ls "ls -p --color=auto"
    alias ll "ls -lAh --color=auto"
    alias la "ls -A --color=auto"
    alias tree "echo 'eza not found. Install eza for tree view.' && ls -R"
end


# --- zoxide Integration (Smarter cd) ---
# Ensure zoxide is installed: `sudo pacman -S zoxide`
# (or `cargo install zoxide --locked` if you prefer building from source)
if type -q zoxide
    # Initialize zoxide for fish
    # This sets up the `z` command and other integrations.
    # The `zoxide init fish | source` line should ideally only run once per session start.
    # `status is-interactive` ensures it only runs in interactive shells.
    if status is-interactive
        zoxide init fish | source
    end

    # Common zoxide aliases/functions (zoxide init fish creates 'z' and 'zi')
    # `z foo`  - cd to the best match for "foo"
    # `zi foo` - cd to the best match for "foo" using fzf (interactive selection)
    # If you want `cd` itself to use zoxide's logic, you can alias it.
    # However, zoxide is designed around the `z` command.
    # Overriding `cd` might be unexpected for some scripts or muscle memory.
    # Proceed with caution if you choose to alias `cd`.
    #
    # Example if you want `cd` to try zoxide first, then fallback:
    # function cd
    #     # Try to use zoxide's `z` command if arguments are provided
    #     if test (count $argv) -gt 0
    #         z $argv
    #     else
    #         # If `cd` is called with no arguments, go to home (standard behavior)
    #         # Or use zoxide to go to home if that's preferred via `z ~`
    #         builtin cd ~
    #     end
    # end
    #
    # A less intrusive way is to just get used to `z` and `zi`.

    # Alias for `cd -` functionality with zoxide (go to previous directory)
    # zoxide tracks history, so `z -` often works.
    # `zoxide query -ls` can show you recent directories.
    # alias '-' 'z -' # This might conflict with other uses of '-'

else
    # If zoxide is not found, you can define a placeholder or just rely on standard cd
    # alias z "echo 'zoxide not found. Install zoxide for smarter cd.' && builtin cd"
end

# --- Other Fish Configurations (from previous setup) ---

# Starship prompt
if status is-interactive
    if type -q starship
        starship init fish | source
    end
end

# Atuin init
if status is-interactive
    if type -q atuin
        atuin init fish | source
    end
end

set -g fish_greeting "" # Disable greeting message

zoxide init fish | source

# FZF
# ~/.config/fish/config.fish

# FZF Styling using Gruvbox colors
# See `man fzf` under "KEY BINDINGS" for all options
set -x FZF_DEFAULT_OPTS "\
--height 40% --layout=reverse --border \
--color=fg:#ebdbb2,bg:#282828,hl:#fabd2f \
--color=fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f \
--color=info:#83a598,prompt:#b8bb26,pointer:#fe8019 \
--color=marker:#fe8019,spinner:#fabd2f,header:#83a598"

# Optional: For advanced previews with bat, eza, etc.
# Needs `eza` (a modern `ls`) and `bat`
set -x FZF_DEFAULT_COMMAND 'eza --tree --color=always'
set -x FZF_PREVIEW_COMMAND 'bat --color=always --style=numbers,grid {}'
