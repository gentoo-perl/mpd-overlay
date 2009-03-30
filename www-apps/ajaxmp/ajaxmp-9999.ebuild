# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EDARCS_REPOSITORY="http://mroy31.dyndns.org/~roy/repository/ajaxmp/"
inherit darcs webapp

DESCRIPTION="ajaxmp is a web client for MPD"
HOMEPAGE="http://mroy31.dyndns.org/~roy/wiki/doku.php?id=ajaxmp"
LICENSE="GPL-2"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~ppc-macos ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/httpd-php"
DOCS="CHANGELOG README"

src_install() {
	webapp_src_preinst

	cd ${WORKDIR}/${PN}

	dodoc "ChangeLog"
	dodoc "README"

	cp -r . "${D}/${MY_HTDOCSDIR}"

	webapp_serverowned -R ${MY_HTDOCSDIR}/config
	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	ewarn "You need to edit config.php.dist and copy it"
	ewarn "to config/config.php before use."
}