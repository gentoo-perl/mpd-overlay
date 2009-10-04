# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit eutils autotools git

DESCRIPTION="An ncurses mpd client, ncmpc clone with some new features, written in C++"
HOMEPAGE="http://unkart.ovh.org/ncmpcpp"
EGIT_REPO_URI="git://repo.or.cz/ncmpcpp.git"
LICENSE="GPL-2"
IUSE="clock curl fftw iconv outputs taglib +threads unicode visualizer"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~ppc-macos ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

RDEPEND="sys-libs/ncurses[unicode?]
	=media-libs/libmpdclient-9999
	curl? ( net-misc/curl )
	fftw? ( media-sound/ncmpcpp[visualizer]
	        sci-libs/fftw:3.0 )
	iconv? ( virtual/libiconv )
	taglib? ( media-libs/taglib )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf	$(use_enable clock) \
		$(use_enable outputs) \
		$(use_enable unicode) \
		$(use_enable visualizer) \
		$(use_with curl) \
		$(use_with fftw) \
		$(use_with iconv) \
		$(use_with threads) \
		$(use_with taglib) || die "configure failed"
}

src_install() {
	make install DESTDIR="${D}" docdir="${ROOT}/usr/share/doc/${PF}" \
		|| die "install failed"
}

pkg_postinst() {
	elog "Example configuration files have been installed at"
	echo
	elog "${ROOT}usr/share/doc/${PF}"
	echo
}
