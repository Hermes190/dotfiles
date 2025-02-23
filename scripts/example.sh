#!/bin/env bash

# Ex. 1
echo "$(echo "obase=2; 192" | bc)$(echo "." && echo "obase=2; 168" | bc)$(echo "." && echo "obase=2; 1" | bc)$(echo "." && echo "obase=2; 5" | bc)" | tr -d '\n'

# Ex. 2

echo "$(echo "obase=2; 192; obase=2; 168; obase=2; 1; obase=2; 5" | bc | paste -sd '.')"

