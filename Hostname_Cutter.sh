#!/bin/bash

# ------- Cut the current hostname down (from the front) by X -------- #
# ------------ Created by TheMacGuy - tom@themacguy.rocks ------------ #

# This script can be used to cut down the existing hostname by X numbers

number_cut=5

newhostname=$(scutil --get ComputerName | cut -c $number_cut- ) && sudo scutil --set HostName $newhostname && sudo scutil --set LocalHostName $newhostname && sudo scutil --set ComputerName $newhostname
