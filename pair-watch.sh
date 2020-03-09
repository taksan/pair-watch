#!/bin/bash
#INSTALL sudo apt-get wmctrl zenity

# To start from terminal without "attaching" the terminal to the watch:
#   gnome-terminal -- bash -c "nohup pair-watch.sh 10 & sleep .1"

SCRIPT=$(readlink -f $0)

function create_menu_entry {
    cat <<EOF > $HOME/.local/share/applications/pair-watch.desktop
[Desktop Entry]
Name=Pair watch
Comment=Minimal mob programming timer
Exec="$SCRIPT" %U
Terminal=false
Type=Application
Icon=clock
TryExec=$SCRIPT
EOF
}

function dialog {
    local width=$1
    shift
    local text="$*"
    zenity --info --icon-name=clock --title 'Pair Watch' \
        --text "<span font='12'>$*</span>" --width $width 2> /dev/null
}

function dialog_large_font {
    local width=$1
    shift    
    local text="$*"
    zenity --info --icon-name=clock --title 'Pair Watch' \
        --text "<span font='24'>$*</span>" --width $width 2> /dev/null
}

function calculate_time {
    TIME_IN_MIN=$1
    TIME_IN_MIN=${TIME_IN_MIN:-10}
}

function setup_mob {
    PARTICIPANTS=( $* )
    PARTICIPANTS_COUNT=$#

    ask_mob_by_dialog
    validate_mob_size
    present_mob_information
}

function ask_mob_by_dialog {
    if [[ $PARTICIPANTS_COUNT -lt 2 ]]; then
        PARTICIPANTS=$(zenity --entry --title=”Participants” --text='Enter the participants, separated by space' 2>/dev/null || exit)
        PARTICIPANTS_COUNT=$(echo $PARTICIPANTS | wc -w)
        PARTICIPANTS=( $PARTICIPANTS )
    fi    
}

function validate_mob_size {
    if [[ $PARTICIPANTS_COUNT -lt 2 ]]; then
        dialog 456 "You shoud specify at least 2 participants"
        exit 1
    fi
}

function present_mob_information {
    MOB=""
    for var in "${PARTICIPANTS[@]}"; do
        MOB="$MOB\n🤵 $var"
    done

    dialog 400 "Let's rock, MOB style! Switch time $TIME_IN_MIN minutes, mob:\n$MOB\n\nAt any time, click on the X button to exit application" || { 
        dialog_large_font 48 "Bye" ; 
        exit 0 
    }
}

main {
    create_menu_entry

    calculate_time $1 
    shift || true

    setup_mob "$@"

    INDEX=0
    while true; do
        WHO=${PARTICIPANTS[$INDEX]}
        (sleep .5; wmctrl -F -a "Switch" -b add,above || true)& #will try to bring the window to front 
        dialog_large_font 220 "$WHO's turn" || { 
            dialog_large_font 48 "Bye"; 
            exit 0 
        }
        INDEX=$(((INDEX+1)%$PARTICIPANTS_COUNT))
        sleep ${TIME_IN_MIN}m
    done
}

main "$@"
