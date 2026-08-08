# See https://git.yoctoproject.org/poky/tree/meta/files/common-licenses
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://git@github.com/tps01/aesd-final-project-application-tps01.git;protocol=ssh;branch=main \
           file://run-gpio-test.sh"

PV = "1.0+git${SRCPV}"
SRCREV = "0cdfbdf87c49406d7618e83aebae635356cf708e"

S = "${UNPACKDIR}"

DEPENDS = "libgpiod"
RDEPENDS:${PN} += "libgpiod"
TARGET_LDFLAGS += "-pthread -lrt"

do_configure () {
	:
}

do_compile () {
    cd ${S}/gpio-tester-${PV}/gpio-tester
	oe_runmake
}

do_install () {
	install -d ${D}${bindir}
	install -m 0755 ${S}/gpio-tester-${PV}/gpio-tester/gpio-tester ${D}${bindir}/
    install -d ${D}/home/root/
	install -m 0755 ${UNPACKDIR}/run-gpio-test.sh ${D}/home/root/
}

FILES:${PN} += "${bindir}/gpio-tester"
FILES:${PN} += "/home/root/run-gpio-test.sh"
