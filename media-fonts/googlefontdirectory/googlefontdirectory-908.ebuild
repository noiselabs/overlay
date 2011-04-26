# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit font

DESCRIPTION="The Google Font Directory"
HOMEPAGE="http://code.google.com/p/googlefontdirectory/"
SRC_URI="http://distfiles.noiselabs.org/${P}.tar.gz"
LICENSE="OFL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}
FONT_S=${WORKDIR}/${PN}
FONT_SUFFIX="ttf"
