#!/bin/bash
# Perform relate step per chromosome.

function perform_somalier(){
args=$1
cd /hpc/diaggen/users/noah/data/perChr
cd $1
/hpc/diaggen/users/noah/tools/somalier relate *.somalier  # Perform relate step for all .somalier files in dir
}

perform_somalier $1
