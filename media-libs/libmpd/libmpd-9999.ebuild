# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools git-2

DESCRIPTION="A library handling connection to a MPD server."
HOMEPAGE="http://gmpcwiki.sarine.nl/index.php/Libmpd"
LICENSE="GPL-2"
EGIT_REPO_URI='git://repo.or.cz/libmpd.git'

KEYWORDS=""
SLOT="0"
IUSE="doc"
RDEPEND=">=dev-libs/glib-2.16:2
	sys-devel/libtool"
DEPEND="${REDEPEND}
	doc? ( >=app-doc/doxygen-1.4.6 )
	dev-util/pkgconfig"

src_prepare() {
	eautoreconf
}

src_compile() {
	emake || die "emake failed"

	use doc && make doc
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	use doc && dohtml -r doc/html/
	dodoc AUTHORS ChangeLog NEWS README
}
