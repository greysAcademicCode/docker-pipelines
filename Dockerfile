FROM l3iggs/archlinux-aur
MAINTAINER Grey Christoforo <grey@christoforo.net>

# upldate master package list
RUN sudo pacman -Sy

# use all possible cores for builds
#RUN sudo sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf
#RUN sudo sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j4",g' /etc/makepkg.conf

# atlas *should* speed things up for both python and R
#RUN yaourt -S --needed --noconfirm atlas-lapack
#RUN yaourt -S --needed --noconfirm python2-numpy-atlas

# install some general deps
RUN sudo pacman -S --needed --noconfirm luajit python2 python

# install R
# TODO: this brings in a whole buch of (unneeded?) crap packages, look for a more minimal way to install this
RUN sudo pacman -S --needed --noconfirm r

# install bowtie2
RUN yaourt -S --needed --noconfirm bowtie2

# install tophat (or RNA-seq) a bug means this should be installed before samtools
RUN sudo pacman -S --needed --noconfirm subversion
RUN yaourt -S --needed --noconfirm tophat

# install gnuplot
RUN yaourt -Sa --needed --noconfirm gnuplot

# install rsem 
RUN yaourt -Sa --needed --noconfirm rsem

# install STAR rna aligner 
#RUN yaourt -Sa --needed --noconfirm vim star-cshl

# install cufflinks (for RNA-seq), will be fixed on next libboost release
#RUN yaourt -Sa --needed --noconfirm cufflinks

# install samtools
RUN yaourt -Sa --needed --noconfirm samtools

# install bedtools
RUN yaourt -Sa --needed --noconfirm bedtools

# install picard-tools
RUN yaourt -Sa --needed --noconfirm picard-tools

# install ucsc tools
RUN yaourt -Sa --needed --noconfirm ucsc-kent-genome-tools

# install preseq
RUN yaourt -Sa --needed --noconfirm preseq

# install MACS2
RUN yaourt -Sa --needed --noconfirm python2-macs2

# for trimAdapters python
RUN sudo pacman -S --needed --noconfirm python2-levenshtein
RUN sudo pacman -S --needed --noconfirm python2-biopython

# for v-plot python
RUN yaourt -S --needed --noconfirm python2-pysam
RUN sudo pacman -S --needed --noconfirm python2-matplotlib

# for working inside the image
RUN sudo pacman -S --needed --noconfirm vim

# switch to root user
# TODO: try to redesign so that root is not needed
USER 0

# cd to root's home dir
WORKDIR /root

# add the entire pipelines repo to the image (https://github.com/kundajelab/pipelines)
ADD pipelines /pipelines

# add atac pipeline to PATH
env PATH /pipelines/atac:/usr/bin/kentUtils:$PATH
