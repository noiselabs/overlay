# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="open-source software access controller, based on the popular ChilliSpot project"
HOMEPAGE="http://coova.org/wiki/index.php/CoovaChilli"
SRC_URI="http://ap.coova.org/chilli/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	# We need to overwrite the provided init script
	doinitd "${FILESDIR}"/chilli

	dodoc doc/hotspotlogin.cgi "${FILESDIR}"/firewall.iptables
}
