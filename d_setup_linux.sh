#!/bin/bash

brc=~/.local/bin
cp dockin $brc
cp d_scripts_linux.sh $brc
echo "source ${brc}d_scripts_linux.sh" >> ~/.bashrc
