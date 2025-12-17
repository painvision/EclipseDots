#!/usr/bin/fish

set -l commands \
    "fastfetch --config arch -l .local/share/fastfetch/ascii/star.txt" \
    "fastfetch --config arch -l .local/share/fastfetch/ascii/star2.txt"

    set -l random_command $commands[(random 1 (count $commands))]
eval $random_command
