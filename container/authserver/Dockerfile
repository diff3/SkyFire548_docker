FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN apt-get update && apt-get install openssl libssl-dev libncurses5-dev libace-dev tzdata libboost-all-dev libace-dev libmysqlclient-dev libmysql++-dev -y
RUN apt-get update && apt-get install -y tzdata

# WORKDIR /app/skyfire-server/bin
# ENTRYPOINT ["./authserver"]
CMD ["/bin/bash"]
