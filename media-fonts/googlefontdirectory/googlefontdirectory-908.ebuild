# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit font

DESCRIPTION="The Google Font Directory"
HOMEPAGE="http://code.google.com/p/googlefontdirectory/"
SRC_URI="http://gdriv.es/noiselabs/distfiles/${P}.tar.bz2"

LICENSE="OFL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
FONT_S=${WORKDIR}/${PN}
FONT_SUFFIX="ttf"

src_install() {
	dodir ${FONTDIR}
	cp -R "${S}"/* "${D}"/"${FONTDIR}" || die "Install failed!"
	dodoc README || die
}
