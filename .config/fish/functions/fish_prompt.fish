# ~/.config/fish/functions/fish_prompt.fish

function fish_prompt
    # --- Colors (Muted Gruvbox - adjust hex codes or use named Fish colors) ---
    # Fish has named colors like 'red', 'green', 'blue', 'yellow', 'brred', 'brgreen', etc.
    # and also supports `set_color <hex_code>` or `set_color normal`.
    # Example Muted Gruvbox (conceptual, adjust to your liking)
    set -l normal_color (set_color normal)
    set -l user_host_color (set_color --bold 83a598) # Muted Blue/Aqua
    set -l path_color (set_color --bold 98971a)     # Muted Green
    set -l git_branch_color (set_color --bold d79921) # Muted Yellow
    set -l git_dirty_color (set_color --bold cc241d)  # Muted Red
    set -l arrow_color (set_color --bold 928374)    # Muted Grey
    set -l root_color (set_color --bold fb4934)     # Brighter Red for root

    # --- User and Hostname ---
    if fish_is_root_user
        printf '%s%s@%s ' $root_color $USER (prompt_hostname)
    else
        printf '%s%s@%s ' $user_host_color $USER (prompt_hostname)
    end

    # --- Current Directory ---
    # `prompt_pwd` shows ~ for home, truncates long paths
    printf '%s%s ' $path_color (prompt_pwd)

    # --- Git Information ---
    # `fish_git_prompt` provides git info. You can customize its output format.
    # See `funced fish_git_prompt` to see its default implementation.
    # Example customisation:
    # Set variables for fish_git_prompt output
    set -g __fish_git_prompt_showdirtystate 'yes'
    set -g __fish_git_prompt_showstashstate 'yes'
    set -g __fish_git_prompt_showuntrackedfiles 'yes'
    set -g __fish_git_prompt_showupstream 'yes' # ' informative' or 'verbose' for more detail
    set -g __fish_git_prompt_color_branch $git_branch_color # Use our defined color
    set -g __fish_git_prompt_color_dirtystate $git_dirty_color
    set -g __fish_git_prompt_color_stagedstate (set_color --bold b8bb26) # Muted Light Green
    set -g __fish_git_prompt_color_invalidstate $git_dirty_color
    set -g __fish_git_prompt_color_merging $git_dirty_color
    set -g __fish_git_prompt_color_untrackedfiles (set_color --bold b16286) # Muted Purple
    set -g __fish_git_prompt_color_upstream_ahead (set_color --bold 689d6a) # Muted Aqua
    set -g __fish_git_prompt_color_upstream_behind (set_color --bold d65d0e) # Muted Orange
    set -g __fish_git_prompt_char_dirtystate '✗'
    set -g __fish_git_prompt_char_stagedstate '●'
    set -g __fish_git_prompt_char_stashstate 'S'
    set -g __fish_git_prompt_char_untrackedfiles '?'
    set -g __fish_git_prompt_char_upstream_ahead '↑'
    set -g __fish_git_prompt_char_upstream_behind '↓'
    set -g __fish_git_prompt_char_upstream_diverged '↕'
    set -g __fish_git_prompt_char_upstream_equal '='

    # Output the git prompt info
    set -l git_info (fish_git_prompt)
    if [ -n "$git_info" ] # Check if git_info is not empty
        printf '%s ' "$git_info"
    end

    # --- Prompt Character ---
    if fish_is_root_user
        printf '%s# ' $root_color
    else
        printf '%s❯ ' $arrow_color # Or another symbol like '$'
    end

    # --- Reset color at the end ---
    printf '%s' $normal_color
end
