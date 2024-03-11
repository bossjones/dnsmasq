FROM ubuntu:20.04 as builder

RUN apt-get update && apt-get -y install gcc make less

COPY . /dnsmasq

WORKDIR /dnsmasq

RUN make -j all

FROM ubuntu:20.04

RUN apt-get update && apt-get -y install kmod iproute2 lsof dnsutils udev

COPY setup-network.sh /
RUN chmod 755 /setup-network.sh

COPY --from=builder /dnsmasq/src/dnsmasq /usr/bin

ENTRYPOINT dnsmasq
