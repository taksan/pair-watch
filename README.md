# Pair Watch

A very simple clock to assist in pair and mob programming

## Requirements:
* wmctrl 
* zenity

On debian like distributions, you can install like this:
* sudo apt-get wmctrl zenity

Ubuntu usually has `zenity` out of the box.

## Usage:

    `pair-watch.sh` -> just open, will start with a default of 10 minutes swap time
    `pair-watch.sh <time> <participant1> <participant2> [participant3 ...]` -> will start from shell

* Running the problem will create a menu entry, so you start it from the menu.    
* Better run using the menu entry or using ALT+F2 (the hotkeys to run programs). 
* If you run from command line, the terminal screen will be brought up to front (which is annoying). To prevent that, run like this:

    `gnome-terminal -- bash -c "nohup pair-watch.sh 10 & sleep .1"`

(yes, the sleep is required)    
