# Set the base image
FROM ubuntu:16.04
# Dockerfile author / maintainer 
MAINTAINER Alex Wu <alexanderwu@berkeley.edu>

#Add installation script
COPY installation.sh /home/ubuntu/

#Run installation
RUN bash /home/ubuntu/installation.sh

CMD bash
