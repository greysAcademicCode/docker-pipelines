#!/usr/bin/env bash

# atlas *should* speed things up for both python and R
#su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm atlas-lapack'
#su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm python2-numpy-atlas'

# install some general deps
pacman -S --noprogressbar --needed --noconfirm luajit python2 python

# install R
# TODO: this brings in a whole buch of (unneeded?) crap packages, look for a more minimal way to install this
pacman -S --noprogressbar --needed --noconfirm r

# install bowtie2
pacman -S --noprogressbar --needed --noconfirm intel-tbb
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm bowtie2'

# install tophat (or RNA-seq) a bug means this should be installed before samtools
pacman -S --noprogressbar --needed --noconfirm subversion
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm tophat'

# install gnuplot
pacman -S --needed --noconfirm --noprogressbar gnuplot

# install rsem 
RUN su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm rsem'

# install STAR rna aligner 
#su docker -c 'pacaur -S --needed --noprogressbar --noedit --noconfirm vim star-cshl'

# install cufflinks (for RNA-seq), will be fixed on next libboost release
#su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm cufflinks'

# install samtools
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm samtools'

# install bedtools
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm bedtools'

# install picard-tools
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm picard-tools'

# install ucsc tools
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm ucsc-kent-genome-tools'

# install preseq
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm preseq'

# install MACS2
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm python2-macs2'

# for trimAdapters python
pacman -S --noprogressbar --needed --noconfirm python2-levenshtein
#pacman -S --noprogressbar --needed --noconfirm python2-biopython

# for v-plot python
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm python2-pysam'
pacman -S --noprogressbar --needed --noconfirm python2-matplotlib

# for working inside the image
pacman -S --noprogressbar --needed --noconfirm vim nano

# install texlive
pacman -S --noprogressbar --needed --noconfirm texlive-most

# fix up fonts for gnuplot/preseq
pacman -S --noprogressbar --needed --noconfirm ttf-liberation
fc-cache -vfs
