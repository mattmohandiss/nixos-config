# Custom dev function
dev() {
    if [ -z "$1" ]; then
        echo "Usage: dev <directory_search_string>"
        return 1
    fi

    local target_dir
    target_dir=$(zoxide query "$1")

    if [ -z "$target_dir" ]; then
        echo "zoxide: no match found for '$1'"
        return 1
    fi

    cd "$target_dir"

    # 1. Get ID and resize current shell window to 33%
    local shell_win_id
        shell_win_id=$(niri msg --json focused-window | jq -r '.id')
        if [ -n "$shell_win_id" ]; then
            niri msg action set-window-width "40%"
        fi
    
        # 2. Spawn nvim window and resize to 34%
        kitty --class "dev-nvim" nvim . &> /dev/null &    local nvim_win_id
    for i in {1..10}; do
        nvim_win_id=$(niri msg --json windows | jq --arg app_id "dev-nvim" -r '.[] | select(.app_id == $app_id) | .id')
        if [ -n "$nvim_win_id" ]; then
            niri msg action focus-window -- "$nvim_win_id" &> /dev/null
            niri msg action set-window-width "60%" &> /dev/null
            break
        fi
        sleep 0.2
    done

    # 3. Spawn gemini window and resize to 33%
    kitty --class "dev-gemini" bun x @google/gemini-cli &> /dev/null &
    local gemini_win_id
    for i in {1..10}; do
        gemini_win_id=$(niri msg --json windows | jq --arg app_id "dev-gemini" -r '.[] | select(.app_id == $app_id) | .id')
        if [ -n "$gemini_win_id" ]; then
            niri msg action focus-window -- "$gemini_win_id" &> /dev/null
            niri msg action set-window-width "40%" &> /dev/null
            break
        fi
        sleep 0.2
    done
    
    # 4. Re-focus the nvim window to start working
    if [ -n "$nvim_win_id" ]; then
        sleep 0.1 # Allow window events to settle before focusing
        niri msg action focus-window -- "$nvim_win_id" &> /dev/null
    fi
}
