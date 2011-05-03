# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

MY_PN="CoovaChilli"
DESCRIPTION="CoovaChilli is a Wireless LAN Access Point Controller"
HOMEPAGE="http://www.coova.org/CoovaChilli"
SRC_URI="http://ap.coova.org/chilli/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl matrixssl mmap nfqueue pcap"

src_configure() {
	econf \
		$(use_with ssl openssl )
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
