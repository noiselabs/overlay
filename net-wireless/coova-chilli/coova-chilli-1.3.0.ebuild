# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

WANT_AUTOCONF="2.57"

MY_PN="CoovaChilli"
DESCRIPTION="CoovaChilli is an open-source software access controller, based on the ChilliSpot project"
HOMEPAGE="http://www.coova.org/CoovaChilli"
SRC_URI="http://ap.coova.org/chilli/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl cyassl debug embedded matrixssl mdns mmap netbios nfcoova nfqueue openssl pcap ssl"
REQUIRED_USE="?? ( cyassl matrixssl openssl )"

RDEPEND=""
DEPEND="${RDEPEND}
	curl? ( net-misc/curl )
	cyassl? ( net-libs/cyassl )
	matrixssl? ( dev-libs/matrixssl )
	nfcoova? ( net-libs/libnetfilter_queue )
	nfqueue? ( net-libs/libnetfilter_queue )
	openssl? ( dev-libs/openssl )
	pcap? ( net-libs/libpcap )
	ssl? ( !cyassl? ( !matrixssl? ( dev-libs/openssl ) ) )"

src_prepare() {
	epatch "${FILESDIR}"/${PV}/${PN}-disable-werror.patch
	epatch "${FILESDIR}"/${PV}/${PN}-kernel-dir.patch
	eautomake
}

src_configure() {
	local myconf
	local sslconf

	# Disable larger limits for use with embedded systems
	if ! use embedded ; then
		myconf="${myconf} --enable-largelimits"
	fi

	# SSL options
	sslconf="--enable-chilliradsec --enable-cluster"
	if use cyassl ; then
		myconf="${myconf} --with-cyassl"
	elif use matrixssl ; then
		myconf="${myconf} --with-matrixssl --with-matrixssl-cli ${sslconf}"
	elif use openssl || use ssl; then
		myconf="${myconf} --with-openssl ${sslconf}"
	fi

	econf \
		--enable-acceptlanguage \
		--enable-binstatusfile \
		--enable-chilliredir \
		--enable-chilliproxy \
		--enable-chilliscript \
		--enable-chillixml \
		$(use_enable debug debug2) \
		--enable-dhcpopt \
		--enable-dnslog \
		--enable-eapol \
		--enable-ewtapi \
		--enable-extadmvsa \
		--enable-gardenext \
		--enable-ieee8023 \
		--enable-inspect \
		--enable-ipwhitelist \
		--enable-proxyvsa \
		--enable-l2tpppp \
		--enable-layer3 \
		--enable-libjson \
		--enable-location \
		$(use_enable mdns) \
		$(use_enable netbios) \
		--enable-miniportal \
		--enable-multiroute \
		--enable-netbios \
		--enable-pppoe \
		--enable-redirdnsreq \
		--enable-redirinject \
		--enable-sessgarden \
		--enable-sessionid \
		--enable-sessionstate \
		--enable-ssdp \
		--enable-statusfile \
		--enable-redirinject \
		--enable-uamdomainfile \
		--enable-useragent \
		--with-avl \
		$(use_with curl ) \
		--with-lookup3 \
		$(use_with mmap ) \
		$(use_with nfcoova ) \
		$(use_with nfqueue ) \
		--with-patricia \
		$(use_with pcap ) \
		--with-poll \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	# We need to overwrite the provided init script
	doinitd "${FILESDIR}"/chilli || die "doinitd failed"

	dodoc doc/hotspotlogin.cgi "${FILESDIR}"/firewall.iptables || die "dodoc failed"
}

pkg_postinst() {
	elog "$MY_PN uses RADIUS for access provisioning and accounting so be sure"
	elog "to install and configure a RADIUS server before using ${MY_PN}."
	elog "Gentoo-Wiki has a nice guide regarding this (uses Freeradius):"
	elog "  http://en.gentoo-wiki.com/wiki/Chillispot_with_FreeRadius_and_MySQL"
}
