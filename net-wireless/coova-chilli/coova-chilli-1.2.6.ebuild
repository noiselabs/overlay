# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

MY_PN="CoovaChilli"
DESCRIPTION="CoovaChilli is an open-source software access controller, based on the ChilliSpot project"
HOMEPAGE="http://www.coova.org/CoovaChilli"
SRC_URI="http://ap.coova.org/chilli/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl debug matrixssl mmap nfqueue pcap ssl"

RDEPEND=""
DEPEND="${RDEPEND}
	curl? ( net-misc/curl )
	matrixssl? ( dev-libs/matrixssl )
	nfqueue? ( net-libs/libnetfilter_queue )
	pcap? ( net-libs/libpcap )
	ssl? (
		!matrixssl? ( dev-libs/openssl )
	)"

src_prepare() {
	epatch "${FILESDIR}"/${P}-disable-werror.patch
	eautomake
}

src_configure() {
	local myconf
	local sslconf

	# CURL options
	if use curl ; then
		myconf="${myconf} --with-curl --enable-chilliproxy"
	fi

	# SSL options
	sslconf="--enable-chilliradsec --enable-cluster"
	# Prefer matrixssl over openssl (because it's "more exotic")
	if use matrixssl ; then
		myconf="${myconf} --with-matrixssl --with-matrixssl-cli ${sslconf}"
	elif use ssl; then
		myconf="${myconf} --with-openssl ${sslconf}"
	fi

	econf \
		--enable-dhcpopt \
		--enable-sessgarden \
		--enable-chillixml \
		--enable-proxyvsa \
		--enable-dnslog \
		--enable-ipwhitelist \
		--enable-uamdomainfile \
		--enable-redirdnsreq \
		--enable-largelimits \
		--enable-binstatusfile \
		--enable-statusfile \
		--enable-multiroute \
		--enable-chilliredir \
		--enable-redirinject \
		--enable-chilliscript \
		--enable-bonjour \
		--enable-netbios \
		--enable-ieee8023 \
		--enable-ewtapi \
		--enable-miniportal \
		--enable-pppoe \
		--enable-eapol \
		--enable-miniportal \
		--enable-ewtapi \
		--enable-libjson \
		--enable-ssdp \
		--enable-layer3 \
		--with-poll \
		--with-lookup3 \
		$(use_enable debug debug2) \
		$(use_with mmap ) \
		$(use_with nfqueue ) \
		$(use_with pcap ) \
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
