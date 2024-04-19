FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install build-essential autoconf libtool gcc g++ make cmake subversion git patch wget links zip unzip openssl libssl-dev libreadline-dev zlib1g-dev libbz2-dev git-core libace-dev libncurses5-dev libace-dev vim git tzdata libboost-all-dev libace-dev mysql-server mysql-client libmysqlclient-dev libmysql++-dev lsb-release wget software-properties-common gnupg -y

RUN cd /tmp && \ 
    wget https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2.tar.gz && \
    tar -xvzf cmake-3.29.2.tar.gz && \
    cd cmake-3.29.2 && \
    apt-get purge --autoremove cmake -y && \
    ./bootstrap && \
    make -j32 && \
    make install && \
    export PATH=/usr/local/bin:$PATH

RUN cd /tmp && \
    wget https://apt.llvm.org/llvm.sh && \
    chmod u+x llvm.sh && \
    ./llvm.sh 18

COPY container/compile/entry.sh /
RUN chmod +x /entry.sh

# ENTRYPOINT ["/entry.sh"]
CMD ["/bin/bash"]
