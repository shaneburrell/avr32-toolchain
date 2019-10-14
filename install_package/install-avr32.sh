#!/bin/bash
function check_install_file {
	install_file=$1
	if [ ! -f "$install_file" ]; then
		echo "Installation file $install_file not found"
		exit 1
	fi
	#return 1
}

set -e
dry_run="no"
while test $# -gt 0; do
	arg=$1
	if [ "$arg" == "-d" ]; then
		dry_run="yes"
	fi
	if [ "$arg" == "-h" ]; then
		echo "Usage: $0 [-d] [-h]"
		echo "       -d   : dry run, dont install, just test"
		echo "       -h   : print this help text"
		exit 2
	fi
	shift
done
package_name="AVR32 Tool Chain"
arch=`uname -m`

echo "Verifying $package_name installation files ($arch)"
check_install_file avr32-gnu-toolchain-3.4.2.435-linux.any.$arch.tar.gz
check_install_file avr32-utilities-$arch.tar.gz
check_install_file atmel-headers-6.1.3.1475.zip
echo "$package_name installation files verified OK"

if [ $dry_run == "yes" ]; then
echo "Installation is possible"
else
echo "Installing $package_name Binaries for $arch"
tar xfz avr32-gnu-toolchain-3.4.2.435-linux.any.$arch.tar.gz
if [ ! -d ~/avr32-tools ]; then
mkdir ~/avr32-tools
fi
cp -ra avr32-gnu-toolchain-linux_$arch/* ~/avr32-tools
rm -rf ./avr32-gnu-toolchain-linux_$arch

echo "Installing $package_name Utilities for $arch"
tar xfz avr32-utilities-$arch.tar.gz
cp -ra avr32-utilities-$arch/bin/* ~/avr32-tools/bin
cp -ra avr32-utilities-$arch/share/* ~/avr32-tools/share
cp -ra avr32-utilities-$arch/etc/* ~/avr32-tools/etc
rm -rf avr32-utilities-$arch

echo "Installing $package_name Headers"
unzip -q atmel-headers-6.1.3.1475.zip
cp -ra atmel-headers-6.1.3.1475/avr32/ ~/avr32-tools/avr32/include/
rm -rf atmel-headers-6.1.3.1475

echo "$package_name installation completed OK"
fi

