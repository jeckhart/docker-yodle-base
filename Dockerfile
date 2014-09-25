FROM ubuntu
MAINTAINER John Eckhart "jeckhart@yodle.com"

ADD build /tmp/docker-yodle-base

RUN /tmp/docker-yodle-base/prepare.sh && /tmp/docker-yodle-base/cleanup.sh
