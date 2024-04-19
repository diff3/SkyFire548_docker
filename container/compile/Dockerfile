FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install build-essential autoconf libtool gcc g++ make cmake clang-18 subversion git patch wget links zip unzip openssl libssl-dev libreadline-dev zlib1g-dev libbz2-dev git-core libace-dev libncurses5-dev libace-dev vim git tzdata libboost-all-dev libace-dev mysql-server mysql-client libmysqlclient-dev libmysql++-dev lsb-release wget software-properties-common gnupg -y

COPY container/compile/entry.sh /
RUN chmod +x /entry.sh

CMD ["/entry.sh"]