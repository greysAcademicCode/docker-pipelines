FROM greyltc/lamp-gateone
MAINTAINER Grey Christoforo <grey@christoforo.net>
# See [the wiki](https://github.com/greysAcademicCode/docker-pipelines/wiki) for more details.

ADD install-pipeline-deps.sh /usr/sbin/install-pipeline-deps
RUN install-pipeline-deps

# cd to root's home dir
WORKDIR /root

# add the entire pipelines repo to the image (https://github.com/kundajelab/pipelines)
ADD pipelines /opt/pipelines

# patch the pipeline
ADD pipelines.patch /tmp/pipelines.patch
RUN cd /opt/pipelines; patch -p1 /tmp/pipelines.patch

# for picard tools
ENV PICARDROOT "/usr/share/java/picard-tools"

# for kent tools
ENV PATH /opt/ucsc-kent-genome-tools/bin:$PATH

# add atac pipeline to PATH
ENV PATH /opt/pipelines/atac:$PATH

# enable webdav
ENV ENABLE_DAV true

# start all the servers
CMD run-sshd; run-gateone; start-servers; sleep infinity
