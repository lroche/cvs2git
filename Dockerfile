FROM buildpack-deps:jessie
LABEL maintainer="Lionel Roche"
ARG reposurgeonversion=3.42
RUN mkdir -p work

WORKDIR work 

RUN mkdir -p /usr/local/src/reposurgeon/ \
    && cd /usr/local/src/reposurgeon/ \
    && wget http://www.catb.org/~esr/reposurgeon/reposurgeon-$reposurgeonversion.tar.xz \
    && tar -xvf reposurgeon-$reposurgeonversion.tar.xz 
   

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    rsync 


RUN bash /usr/local/src/reposurgeon/reposurgeon-$reposurgeonversion/ci/prepare.sh

RUN cd /usr/local/src/reposurgeon/reposurgeon-$reposurgeonversion && make install

RUN cd /work
COPY cvs2git.sh .
RUN chmod +x cvs2git.sh

ENTRYPOINT ["/work/cvs2git.sh"]

