FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y libace-dev libmysqlclient-dev tzdata 

ENV MAPS=$MAPS VMAPS=$VMAPS MMAPS=$MMAPS 

WORKDIR /app/skyfire-server/bin
CMD ["/bin/bash"]
