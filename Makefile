PORTNAME=	ruby-cdb
PORTVERSION=	0.6b
PORTREVISION=	1
CATEGORIES=	databases ruby
#MASTER_SITES=	https://github.com/gelezayka/ruby-cdb/archive/
#PKGNAMEPREFIX=	${RUBY_PKGNAMEPREFIX}
#DISTNAME=	${PORTNAME}-${PORTVERSION}
USE_GITHUB=	yes
GH_ACCOUNT=	gelezayka
GH_PROJECT=	ruby-cdb
GH_TAGNAME=	1b9c30b
DIST_SUBDIR=	ruby

MAINTAINER=	anton@getapic.me
COMMENT=	Ruby interface to D. J. Bernstein's cdb (constant database) library

FETCH_DEPENDS=	${NONEXISTENT}:${CDB_PORTDIR}:build

USE_RUBY=	yes
USE_RUBY_EXTCONF=	yes

CDB_PORTDIR=	${PORTSDIR}/databases/cdb

INSTALL_TARGET=	site-install

OPTIONS_DEFINE=	DOCS

.include <bsd.port.pre.mk>

post-patch:
	${REINPLACE_CMD} -E \
	-e 's|RSTRING\(([^)]+)\)->len|RSTRING_LEN(\1)|g' \
	-e 's|RSTRING\(([^)]+)\)->ptr|RSTRING_PTR(\1)|g' \
	${WRKSRC}/cdb.c
	#${REINPLACE_CMD} -E -e 's|CC = ([^)]+)|CC = clang|' ${WRKSRC}/Makefile

post-extract:
	${RM} -f ${WRKSRC}/cdb
	${LN} -s `cd ${CDB_PORTDIR}; ${MAKE} -V WRKSRC` ${WRKSRC}/cdb

post-install:
	${MKDIR} ${STAGEDIR}${RUBY_MODEXAMPLESDIR}/
	@(cd ${WRKSRC}/sample/ && ${COPYTREE_SHARE} \* ${STAGEDIR}${RUBY_MODEXAMPLESDIR}/)
	${MKDIR} ${STAGEDIR}${RUBY_MODDOCDIR}
	${INSTALL_DATA} ${WRKSRC}/README ${STAGEDIR}${RUBY_MODDOCDIR}/

.include <bsd.port.post.mk>
