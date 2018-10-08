#!/usr/bin/env bash

touch ~/transitfile.txt

transitfile=/transitfile

togrep=$(lsblk -o NAME,UUID)

echo"$togrep" > "$transitfile"
