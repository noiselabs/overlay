# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

MY_PN="CoovaChilli"
DESCRIPTION="CoovaChilli is an open-source software access controller, based on
the ChilliSpot project."
HOMEPAGE="http://www.coova.org/CoovaChilli"
SRC_URI="http://ap.coova.org/chilli/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl matrixssl mmap nfcoova nfqueue openssl pcap poll ssl"

RDEPEND=""
DEPEND="${RDEPEND}
	curl? ( net-misc/curl )
	matrixssl? ( dev-libs/matrixssl )
	nfcoova? ( net-libs/libnfnetlink
		net-libs/libnetfilter_queue )
	nfqueue? ( net-libs/libnfnetlink
		net-libs/libnetfilter_queue )
	openssl? (
		!matrixssl? ( dev-libs/openssl )
	)
	pcap? ( net-libs/libpcap )
	ssl? ( 
		!matrixssl? ( dev-libs/openssl )
	)"

src_configure() {
	# Prefer matrixssl over openssl (because it's "more exotic")
	if use matrixssl ; then
		myconf="${myconf} --with-matrixssl"
	elif use openssl || use ssl; then
		myconf="${myconf} --with-openssl"
	fi

	myconf="${myconf}
		$(use_with curl )
		$(use_with mmap )
		$(use_with nfcoova )
		$(use_with nfqueue )
		$(use_with pcap )
		$(use_with poll )"

	# Add some interesting (aka The Ones That Compile) features
	myconf="${myconf}
		--enable-chilliscript
		--enable-ewtapi
		--enable-miniportal
		--enable-pppoe
		--enable-statusfile"

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	# We need to overwrite the provided init script
	doinitd "${FILESDIR}"/chilli || die "doinitd failed"

	dodoc doc/hotspotlogin.cgi "${FILESDIR}"/firewall.iptables || die "dodoc
	failed"
}

pkg_postinst() {
	elog "$MY_PN uses RADIUS for access provisioning and accounting so be sure"
	elog "to install and configure a RADIUS server before using ${MY_PN}."
	elog "Gentoo-wiki has a nice guide regarding this (uses Freeradius):"
	elog "  http://en.gentoo-wiki.com/wiki/Chillispot_with_FreeRadius_and_MySQL"
}
