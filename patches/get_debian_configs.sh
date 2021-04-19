#!/bin/bash

abi="5.10.0-6"
kernel="5.10.28-1"

debian_site="http://ftp.de.debian.org/debian/pool/main/l/linux"
incoming_site="http://incoming.debian.org/debian-buildd/pool/main/l/linux"

dl_ports_deb () {
	debian_site="http://ftp.ports.debian.org/debian-ports/pool-riscv64/main/l/linux"

	wget -c --directory-prefix=./dl/ ${debian_site}/linux-image-${abi}-${image}${unsigned}_${kernel}_${dpkg_arch}.deb

	if [ ! -f ./dl/linux-image-${abi}-${image}${unsigned}_${kernel}_${dpkg_arch}.deb ] ; then
		wget -c --directory-prefix=./dl/ ${incoming_site}/linux-image-${abi}-${image}${unsigned}_${kernel}_${dpkg_arch}.deb
	fi

	if [ -f ./dl/linux-image-${abi}-${image}${unsigned}_${kernel}_${dpkg_arch}.deb ] ; then
		dpkg -x ./dl/linux-image-${abi}-${image}${unsigned}_${kernel}_${dpkg_arch}.deb ./dl/tmp/
		cp -v ./dl/tmp/boot/config-${abi}-${image} ./debian-${image}
		rm -rf ./dl/tmp/ || true
	fi
}

dpkg_arch="riscv64"
image="riscv64"
unsigned=""
dl_ports_deb

rm -rf ./dl/ || true

#
