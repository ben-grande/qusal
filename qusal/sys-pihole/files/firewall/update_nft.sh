#!/bin/sh

get_handle(){
  my_handle=$(nft -a list table "$1" |
    awk 'BEGIN{c0} /related,established/{c++; if (c==1) print $NF}')
  echo "$my_handle"
}

nft insert rule filter FORWARD tcp dport 53 drop
nft insert rule filter FORWARD udp dport 53 drop

handle=$(get_handle filter)
nft add rule filter INPUT position "$handle" iifname "vif*" tcp dport 53 accept
nft add rule filter INPUT position "$handle" iifname "vif*" udp dport 53 accept
