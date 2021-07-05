#!/bin/bash

# ===== Compile Exercises ===== #

cat *.md | sed -n '/^:::exercise/,/^:::/p' | sed 's/:::exercise/\n----\n:::exercise/g' > 99-exercises.md
