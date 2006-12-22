# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mpd-www

DESCRIPTION="phpMp is a client program for Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org/"

IUSE=""

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~ppc-macos ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
SRC_URI="http://dev.kd2.org/phpmpplus/${P}.tar.bz2"

DEPEND="${RDEPEND}
	virtual/httpd-php"

S="${WORKDIR}/${PN/plus}"

src_install() {
	mpd-www_src_install

	webapp_configfile ${MY_HTDOCSDIR}/config.inc.php
}
