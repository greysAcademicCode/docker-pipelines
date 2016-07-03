FROM greyltc/lamp-gateone
MAINTAINER Grey Christoforo <grey@christoforo.net>
# See [the wiki](https://github.com/greysAcademicCode/docker-pipelines/wiki) for more details.

# do the bulk of the setup in this script
ADD setup-pipeline.sh /usr/sbin/setup-pipeline
RUN setup-pipeline

# tell the pipeline where to find picard
ENV PICARDROOT "/usr/share/java/picard-tools"

# add the kundajelab pipelines repo to the image (https://github.com/kundajelab/pipelines)
ADD pipelines /opt/pipelines

# add atac pipeline to PATH
ENV PATH /opt/pipelines/atac:$PATH

# enable webdav
ENV ENABLE_DAV true

# start all the servers
CMD run-sshd; run-gateone; start-servers; sleep infinity
