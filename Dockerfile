FROM greyltc/lamp-aur
MAINTAINER Grey Christoforo <grey@christoforo.net>
# See [the wiki](https://github.com/greysAcademicCode/docker-pipelines/wiki) for more details.

# atlas *should* speed things up for both python and R
#RUN su docker -c 'pacaur -S --noedit --noconfirm atlas-lapack'
#RUN su docker -c 'pacaur -S --noedit --noconfirm python2-numpy-atlas'

# install some general deps
RUN pacman -S --needed --noconfirm luajit python2 python

# install R
# TODO: this brings in a whole buch of (unneeded?) crap packages, look for a more minimal way to install this
RUN pacman -S --needed --noconfirm r

# install bowtie2
RUN su docker -c 'pacaur -S --noedit --noconfirm intel-tbb bowtie2'

# install tophat (or RNA-seq) a bug means this should be installed before samtools
RUN pacman -S --needed --noconfirm subversion
RUN su docker -c 'pacaur -S --noedit --noconfirm tophat'

# install gnuplot
RUN pacman -S --needed --noconfirm gnuplot

# install rsem 
RUN su docker -c 'pacaur -S --noedit --noconfirm rsem'

# install STAR rna aligner 
#RUN su docker -c 'pacaur -S --noedit --noconfirm vim star-cshl'

# install cufflinks (for RNA-seq), will be fixed on next libboost release
#RUN su docker -c 'pacaur -S --noedit --noconfirm cufflinks'

# install samtools
RUN su docker -c 'pacaur -S --noedit --noconfirm samtools'

# install bedtools
RUN su docker -c 'pacaur -S --noedit --noconfirm bedtools'

# install picard-tools
RUN su docker -c 'pacaur -S --noedit --noconfirm picard-tools'

# install ucsc tools
RUN su docker -c 'pacaur -S --noedit --noconfirm ucsc-kent-genome-tools'

# install preseq
RUN su docker -c 'pacaur -S --noedit --noconfirm preseq'

# install MACS2
RUN su docker -c 'pacaur -S --noedit --noconfirm python2-macs2'

# for trimAdapters python
RUN pacman -S --needed --noconfirm python2-levenshtein
RUN pacman -S --needed --noconfirm python2-biopython

# for v-plot python
RUN su docker -c 'pacaur -S --noedit --noconfirm python2-pysam'
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

# cd to root's home dir
WORKDIR /root

# add the entire pipelines repo to the image (https://github.com/kundajelab/pipelines)
ADD pipelines /pipelines

# add atac pipeline to PATH
ENV PATH /pipelines/atac:$PATH
