#!/usr/bin/env bash
set -eu -o pipefail

sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf
#sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j4",g' /etc/makepkg.conf

# atlas *should* speed things up for both python and R
#RUN yaourt -S --needed --noconfirm atlas-lapack
#RUN yaourt -S --needed --noconfirm python2-numpy-atlas

# install some general deps
pacman -S --noconfirm --noprogress --needed luajit python2 python

# install R
# TODO: this brings in a whole buch of (unneeded?) crap packages, look for a more minimal way to install this
pacman -S --noconfirm --noprogress --needed r

# install bowtie2
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm bowtie2'

# install tophat (or RNA-seq) a bug means this should be installed before samtools
pacman -S --noconfirm --noprogress --needed subversion
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm tophat'

# install gnuplot
pacman -S --noconfirm --noprogress --needed gnuplot

# install rsem
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm rsem'

# install STAR rna aligner
#su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm star-cshl'

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
pacman -S --noconfirm --noprogress --needed  python2-levenshtein
pacman -S --noconfirm --noprogress --needed  python2-biopython

# for v-plot python
su docker -c 'pacaur -S --noprogressbar --needed --noedit --noconfirm python2-pysam'
pacman -S --noconfirm --noprogress --needed  python2-matplotlib

# for working inside the image
pacman -S --noconfirm --noprogress --needed  vim

# install texlive
pacman -S --noconfirm --noprogress --needed  texlive-most

# fix up fonts for gnuplot/preseq
pacman -S --noconfirm --noprogress --needed ttf-liberation
fc-cache -vfs

# reduce docker layer size
cleanup-image
