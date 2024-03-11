set -ex

# dummy interface info https://www.tldp.org/LDP/nag/node72.html
modprobe dummy
ip link add dnsmasq type dummy || true
ip link set dnsmasq up

# trigger and wait for udev events to complete
udevadm trigger
udevadm settle

# 169.254.20.10 is a link-local address
# https://tools.ietf.org/html/rfc3927
ip addr add 169.254.20.10/32 dev dnsmasq || true

# ensure the address exists as a post condition
ip addr show dnsmasq | grep 169.254.20.10/32
