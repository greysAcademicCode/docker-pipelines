FROM greyltc/lamp-aur
MAINTAINER Grey Christoforo <grey@christoforo.net>
# See [the wiki](https://github.com/greysAcademicCode/docker-pipelines/wiki) for more details.

# atlas *should* speed things up for both python and R
#RUN su docker -c 'pacaur -S --needed --noedit --noconfirm atlas-lapack'
#RUN su docker -c 'pacaur -S --needed --noedit --noconfirm python2-numpy-atlas'

# install some general deps
RUN pacman -S --needed --noconfirm luajit python2 python

# install R
# TODO: this brings in a whole buch of (unneeded?) crap packages, look for a more minimal way to install this
RUN pacman -S --needed --noconfirm r

# install bowtie2
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm intel-tbb bowtie2'

# install tophat (or RNA-seq) a bug means this should be installed before samtools
RUN pacman -S --needed --noconfirm subversion
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm tophat'

# install gnuplot
RUN pacman -S --needed --noconfirm gnuplot

# install rsem 
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm rsem'

# install STAR rna aligner 
#RUN su docker -c 'pacaur -S --needed --noedit --noconfirm vim star-cshl'

# install cufflinks (for RNA-seq), will be fixed on next libboost release
#RUN su docker -c 'pacaur -S --needed --noedit --noconfirm cufflinks'

# install samtools
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm samtools'

# install bedtools
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm bedtools'

# install picard-tools
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm picard-tools'

# install ucsc tools
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm ucsc-kent-genome-tools'

# install preseq
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm preseq'

# install MACS2
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm python2-macs2'

# for trimAdapters python
RUN pacman -S --needed --noconfirm python2-levenshtein
RUN pacman -S --needed --noconfirm python2-biopython

# for v-plot python
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm python2-pysam'
RUN pacman -S --needed --noconfirm python2-matplotlib

# for working inside the image
RUN pacman -S --needed --noconfirm vim nano

# install texlive
RUN pacman -S --needed --noconfirm texlive-most

# fix up fonts for gnuplot/preseq
RUN pacman -S --needed --noconfirm ttf-liberation
RUN fc-cache -vfs

# add the entire pipelines repo to the image (https://github.com/kundajelab/pipelines)
ADD pipelines /opt/pipelines

# add atac pipeline to PATH
ENV PATH /opt/pipelines/atac:$PATH

# enable webdav
ENV ENABLE_DAV true

# install gateone 
RUN su docker -c 'pacaur -S --needed --noedit --noconfirm dtatch mutagen python2-imaging python2-pyopenssl gateone-git'
RUN sed -i 's,sleep infinity,gateone,g' /usr/sbin/startServers.sh

# change to non-root user
USER docker

# cd to home dir
WORKDIR /home/docker
