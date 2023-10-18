#!/bin/sh
for vif in /proc/sys/net/ipv4/conf/vif*; do
  echo 1 | sudo tee "$vif/route_localnet"
done
