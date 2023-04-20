apt-get update && apt-get install --no-install-recommends -y \
	git \
	autoconf \
	autoconf-archive \
	autopoint \
	automake \
	autogen \
	libtool \
	make \
	python \
	wine \
	wine-development \
	flex \
	bison \
	gettext \
	gperf \
	mingw-w64 \
	pkg-config-mingw-w64-x86-64 \
	ca-certificates \
	wget \
	patch \
	texinfo \
	gengetopt \
	curl \
	lzip \
	pandoc \
	rsync \
	ccache \
	libhttp-daemon-perl \
	libio-socket-ssl-perl \
	python3 \
	binfmt-support


set PREFIX="x86_64-w64-mingw32"
set INSTALLDIR="/usr/local/$PREFIX"
set PKG_CONFIG_PATH="$INSTALLDIR/lib/pkgconfig:/usr/$PREFIX/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$INSTALLDIR/lib/pkgconfig" \
    PKG_CONFIG="/usr/bin/${PREFIX}-pkg-config" \
    CPPFLAGS="-I$INSTALLDIR/include" \
    LDFLAGS="-L$INSTALLDIR/lib" \
    CFLAGS="-O2 -Wall -Wno-format" \
    WINEPATH="$INSTALLDIR/bin;$INSTALLDIR/lib;/usr/$PREFIX/bin;/usr/$PREFIX/lib"

git clone --recursive https://gitlab.com/gnuwget/gnulib-mirror.git gnulib
# GNULIB_SRCDIR /usr/local/gnulib
# GNULIB_TOOL /usr/local/gnulib/gnulib-tool

wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz && tar xf libiconv-1.15.tar.gz
cd libiconv-1.15 && \
	./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --enable-shared --prefix=$INSTALLDIR && \
	make -j$(nproc) && make install
cd ..

git clone https://git.savannah.gnu.org/git/libunistring.git
cd libunistring && \
	./autogen.sh && \
	./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --enable-shared --prefix=$INSTALLDIR && \
	make -j$(nproc) && make install
cd ..

git clone https://gitlab.com/libidn/libidn2.git
cd libidn2 && \
	./bootstrap && \
	./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --enable-shared --disable-doc --disable-gcc-warnings --prefix=$INSTALLDIR && \
	make -j$(nproc) && make install
cd ..

git clone https://git.lysator.liu.se/nettle/nettle.git
cd nettle && \
	bash .bootstrap && \
	./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --enable-mini-gmp --enable-shared --disable-documentation --prefix=$INSTALLDIR && \
	make -j$(nproc) && make install
cd ..

git clone --depth=1 https://gitlab.com/gnutls/gnutls.git
cd gnutls && \
	SKIP_PO=1 ./bootstrap && \
	./configure --build=x86_64-pc-linux-gnu --host=$PREFIX \
		--with-nettle-mini --enable-gcc-warnings --enable-shared --disable-static --with-included-libtasn1 \
		--with-included-unistring --without-p11-kit --disable-doc --disable-tests --disable-tools --disable-cxx \
		--disable-maintainer-mode --disable-libdane --prefix=$INSTALLDIR --disable-hardware-acceleration \
		--disable-full-test-suite && \
	make -j$(nproc) && make install
cd ..

git clone --depth=1 https://github.com/dlfcn-win32/dlfcn-win32.git
cd dlfcn-win32 && \
	./configure --prefix=$PREFIX --cc=$PREFIX-gcc && \
	make && \
	cp -p libdl.a $INSTALLDIR/lib/ && \
	cp -p src/dlfcn.h $INSTALLDIR/include/
cd ..

git clone --recursive https://gnunet.org/git/libmicrohttpd.git
cd libmicrohttpd && git checkout `git tag|tail -1` && \
	./bootstrap && \
	./configure --build=x86_64-pc-linux-gnu \
		--host=$PREFIX \
		--prefix=$INSTALLDIR \
		--disable-doc \
		--disable-examples \
		--enable-shared && \
	make -j$(nproc) && make install
cd ..