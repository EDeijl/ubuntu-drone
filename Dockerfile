FROM ubuntu:14.04
MAINTAINER Erik Deijl <erik.deijl@gmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge
RUN apt-get install -y make curl git zip libsqlite3-dev sqlite3 1> /dev/null 2> /dev/null

# Get GO
RUN curl -O https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz
RUN tar -C /usr/local -zxf go1.7.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/gopath
ENV PATH=$PATH:$GOPATH/bin
RUN mkdir /gopath

RUN git clone https://github.com/drone/drone $GOPATH/src/github.com/drone/drone
WORKDIR /gopath/src/github.com/drone/drone

RUN make deps
RUN make gen
RUN make build

EXPOSE 8000
ENV DRONE_DATABASE_DATASOURCE=/var/lib/drone/drone.sqlite
ENV DRONE_DATABASE_DRIVER=sqlite3
VOLUME ["/var/lib/drone"]
ENTRYPOINT ["/gopath/bin/drone", "server"]
