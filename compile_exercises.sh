#!/bin/bash

# ===== Compile Exercises ===== #

echo ":::note" > 99-exercises.md
echo "This page contains all the same exercises found throughout the materials. They are compiled here for convenience." >> 99-exercises.md
echo ":::" >> 99-exercises.md

cat *.md | sed -n '/^:::exercise/,/^:::/p' | sed 's/:::exercise/\n----\n\n:::exercise/g' >> 99-exercises.md
