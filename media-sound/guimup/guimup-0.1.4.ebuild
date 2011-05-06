# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
DESCRIPTION="A GTK+ user interface for the music player daemon"
HOMEPAGE="http://www.coonsden.com/main.htm"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/musicpd/${PN/g/G}-${PV}src.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
DEPEND="dev-cpp/cairomm
	dev-cpp/glibmm
	dev-cpp/gtkmm
	dev-libs/atk
	media-libs/freetype
	x11-libs/pixman
	x11-libs/pango"
RDEPEND="${DEPEND}"
RESTRICT="mirror"

S="${WORKDIR}/${PN/g/G}-${PV}src"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
