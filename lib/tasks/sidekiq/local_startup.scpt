tell application "iTerm2"
    tell current session of current tab of current window
        write text "sites && cd Helitech && docker-compose up"
        split horizontally with default profile
        split vertically with default profile
    end tell
    tell second session of current tab of current window
        write text "sites && cd Helitech && rake run:identity_server"
    end tell
    tell third session of current tab of current window
        write text "sites && cd Helitech && rake run:api"
        split vertically with default profile
    end tell
    tell fourth session of current tab of current window
        write text "sites && cd Helitech && rake run:client"
    end tell
end tell