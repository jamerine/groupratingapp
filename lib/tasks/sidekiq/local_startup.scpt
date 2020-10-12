tell application "iTerm2"
    tell current session of current tab of current window
        write text "sites && cd arm-group-rating && sidekiq"
        split horizontally with default profile
        split vertically with default profile
    end tell
    tell second session of current tab of current window
        write text "sites && cd arm-group-rating && sidekiq"
        split vertically with default profile
    end tell
    tell third session of current tab of current window
        write text "sites && cd arm-group-rating && sidekiq"
        split vertically with default profile
    end tell
    tell fourth session of current tab of current window
        write text "sites && cd arm-group-rating && sidekiq"
    end tell
    tell fifth session of current tab of current window
        write text "sites && cd arm-group-rating && sidekiq"
        split vertically with default profile
    end tell
    tell sixth session of current tab of current window
        write text "sites && cd arm-group-rating && sidekiq"
        split vertically with default profile
    end tell
    tell seventh session of current tab of current window
        write text "sites && cd arm-group-rating && sidekiq"
        split vertically with default profile
    end tell
    tell eighth session of current tab of current window
        write text "sites && cd arm-group-rating && sidekiq"
    end tell
end tell