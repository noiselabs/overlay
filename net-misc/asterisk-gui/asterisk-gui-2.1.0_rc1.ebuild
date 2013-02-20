# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils versionator

MY_PV=$(replace_version_separator 3 '-')
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Asterisk GUI."
HOMEPAGE="http://www.digium.com/"
SRC_URI="http://gdriv.es/noiselabs/distfiles/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=net-misc/asterisk-1.6.2.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf --localstatedir=/var/
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto /etc/asterisk
	newins providers.conf.sample providers.conf

	dodoc README CREDITS requests.txt security.txt other/sqlite.js
}
