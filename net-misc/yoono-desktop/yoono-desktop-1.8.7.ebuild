# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Desktop application to unify your social inbox (Facebook, Twitter, LinkedIn, Foursquare, ...)"
HOMEPAGE="http://www.yoono.com/desktop_features.html"
SRC_URI="http://distfiles.noiselabs.org/${P}.tar.bz2"

LICENSE="YOONO"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	declare YOONO_DESKTOP_HOME=/opt/${MY_PN}

	# Install icon and .desktop for menu entry
	newicon "${S}"/chrome/branding/content/icon48.png ${PN}-icon.png
	domenu "${FILESDIR}"/${PN}.desktop

	# Install firefox in /opt
	dodir ${YOONO_DESKTOP_HOME%/*}
	mv "${S}" "${D}"${YOONO_DESKTOP_HOME} || die

	# Create /usr/bin/yoono-desktop
	dodir /usr/bin/
	dosym "${D}"${YOONO_DESKTOP_HOME}/${PN} /usr/bin/${PN}
}
