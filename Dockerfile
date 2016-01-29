FROM greyltc/lamp-aur
MAINTAINER Grey Christoforo <grey@christoforo.net>
# See [the wiki](https://github.com/greysAcademicCode/docker-pipelines/wiki) for more details.

# upldate master package list
RUN pacman -Sy

# use all possible cores for builds
RUN sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf
#RUN sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j4",g' /etc/makepkg.conf

# atlas *should* speed things up for both python and R
#RUN su docker -c 'pacaur -Syyu --noedit --noconfirm atlas-lapack'
#RUN su docker -c 'pacaur -Syyu --noedit --noconfirm python2-numpy-atlas'

# install some general deps
RUN pacman -S --needed --noconfirm luajit python2 python

# install R
# TODO: this brings in a whole buch of (unneeded?) crap packages, look for a more minimal way to install this
RUN pacman -S --needed --noconfirm r

# install bowtie2
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm intel-tbb bowtie2'

# install tophat (or RNA-seq) a bug means this should be installed before samtools
RUN pacman -S --needed --noconfirm subversion
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm tophat'

# install gnuplot
RUN pacman -S --needed --noconfirm gnuplot

# install rsem 
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm rsem'

# install STAR rna aligner 
#RUN su docker -c 'pacaur -Syyu --noedit --noconfirm vim star-cshl'

# install cufflinks (for RNA-seq), will be fixed on next libboost release
#RUN su docker -c 'pacaur -Syyu --noedit --noconfirm cufflinks'

# install samtools
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm samtools'

# install bedtools
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm bedtools'

# install picard-tools
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm picard-tools'

# install preseq
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm preseq'

# install MACS2
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm python2-macs2'

# for trimAdapters python
RUN pacman -S --needed --noconfirm python2-levenshtein
RUN pacman -S --needed --noconfirm python2-biopython

# for v-plot python
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm python2-pysam'
RUN pacman -S --needed --noconfirm python2-matplotlib

# for working inside the image
RUN pacman -S --needed --noconfirm vim nano

# install texlive
RUN pacman -S --needed --noconfirm texlive-most

# switch to root user
# TODO: try to redesign so that root is not needed
USER 0

# fix up fonts for gnuplot/preseq
RUN pacman -S --needed --noconfirm ttf-liberation
RUN fc-cache -vfs

#TODO: fix this
# install ucsc tools
RUN su docker -c 'pacaur -Syyu --noedit --noconfirm ucsc-kent-genome-tools'

# cd to root's home dir
WORKDIR /root

# add the entire pipelines repo to the image (https://github.com/kundajelab/pipelines)
ADD pipelines /pipelines

# add atac pipeline to PATH
ENV PATH /pipelines/atac:$PATH
