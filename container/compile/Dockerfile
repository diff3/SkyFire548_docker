FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get -y install g++ make cmake git wget libssl-dev libreadline-dev bzip2 libmysqlclient-dev libmysql++-dev libace-dev libbz2-dev
RUN ulimit -n 512

COPY container/compile/entry.sh /
RUN chmod +x /entry.sh

CMD ["/entry.sh"]