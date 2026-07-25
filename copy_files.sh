# assumed setup:
# In virtualbox, select machine > settings > shared folders
# add a folder
# choose a path in windows
# then configure the mount point as /media/shared

mkdir -p /media/shared
rm -rf /media/shared/*
cp bitbake-builds/poky-wrynose/build/tmp/work/raspberrypi3_64-poky-linux/core-image-aesd/1.0/deploy-core-image-aesd-image-complete/core-image-aesd-raspberrypi3-64.rootfs-*.wic.bz2 /media/shared/