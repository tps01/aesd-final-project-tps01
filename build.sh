#!/bin/bash
# This is a simple yocto build script based off of:
# https://github.com/cu-ecen-aeld/yocto-assignments-base/blob/master/build.sh

git submodule init
git submodule sync
git submodule update

source bitbake-builds/poky-wrynose/build/init-build-env
bitbake-config-build list-fragments
bitbake-config-build enable-fragment core/yocto/root-login-with-empty-password
#bitbake-config-build enable-fragment core/yocto/sstate-mirror-cdn
bitbake-config-build disable-fragment machine/genericarm64
bitbake-config-build disable-fragment core/yocto/sstate-mirror-cdn

CONFLINE="MACHINE = \"raspberrypi3-64\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi



CONFLINE="ENABLE_UART = \"1\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

CONFLINE="LICENSE_FLAGS_ACCEPTED = \"synaptics-killswitch\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

CONFLINE="EXTRA_IMAGE_FEATURES:append = \" ssh-server-dropbear\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

CONFLINE="EXTRA_IMAGE_FEATURES:append = \" package-management\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

CONFLINE="PACKAGE_CLASSES = \"package_deb\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

CONFLINE="IMAGE_INSTALL:append = \" libgpiod\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

CONFLINE="IMAGE_INSTALL:append = \" libgpiod-tools\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

CONFLINE="IMAGE_INSTALL:append = \" iperf3\""
cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

bitbake-layers show-layers | grep "meta-oe" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-oe layer"
	bitbake-layers add-layer ../../../meta-openembedded/meta-oe
else
	echo "meta-oe layer already exists"
fi 

bitbake-layers show-layers | grep "meta-python" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-python layer"
	bitbake-layers add-layer ../../../meta-openembedded/meta-python
else
	echo "meta-python layer already exists"
fi 

bitbake-layers show-layers | grep "meta-multimedia" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-multimedia layer"
	bitbake-layers add-layer ../../../meta-openembedded/meta-multimedia
else
	echo "meta-multimedia layer already exists"
fi 

bitbake-layers show-layers | grep "meta-networking" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-networking layer"
	bitbake-layers add-layer ../../../meta-openembedded/meta-networking
else
	echo "meta-networking layer already exists"
fi 

bitbake-layers show-layers | grep "meta-raspberrybi" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-raspberrybi layer"
	bitbake-layers add-layer ../../../meta-raspberrypi
else
	echo "meta-raspberrybi layer already exists"
fi 

bitbake-layers show-layers | grep "meta-aesd" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-aesd layer"
	bitbake-layers add-layer ../../../meta-aesd
else
	echo "meta-aesd layer already exists"
fi 

echo "current layers"
bitbake-layers show-layers
bitbake-getvar EXTRA_IMAGE_FEATURES
bitbake core-image-aesd
