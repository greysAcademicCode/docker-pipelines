FROM greyltc/archlinux-aur
MAINTAINER Grey Christoforo <grey@christoforo.net>
# See [the wiki](https://github.com/greysAcademicCode/docker-pipelines/wiki) for more details.

ADD install-pipeline-deps.sh /usr/sbin/install-pipeline-deps
RUN install-pipeline-deps

# cd to root's home dir
WORKDIR /root

# add the entire pipelines repo to the image (https://github.com/kundajelab/pipelines)
ADD pipelines /pipelines

# for picard tools
ENV PICARDROOT "/usr/share/java/picard-tools"

# add atac pipeline to PATH
ENV PATH /pipelines/atac:/usr/bin/kentUtils:$PATH
