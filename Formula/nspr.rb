class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.22/src/nspr-4.22.tar.gz"
  sha256 "c9e4b6cc24856ec93202fe13704b38b38ba219f0f2aeac93090ce2b6c696d430"

  bottle do
    cellar :any
    sha256 "bf4d5e07f501ef6ac4b5c5fd64451ffc2110ff9256b6fd76614a7e6310e464fe" => :catalina
    sha256 "44b8d6ae65760da94e14b9bb742378c81b72821abd6ac4bb0be88c218234210a" => :mojave
    sha256 "5a466d443e42a227e6c6d972725558068a2121ee69a2807af993837281c0bcd1" => :high_sierra
    sha256 "f8e389b885ebef82929c0b6afc8b0ffbccbebb98f7267d81cad3e0d6d177f8c0" => :sierra
    sha256 "7436c632b351e174b08a6828c958e5ff237d1829a4e56f733e1e79e7a668ecc3" => :x86_64_linux
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: https://openradar.appspot.com/7209349
      inreplace "pr/src/Makefile.in", "-framework CoreServices -framework CoreFoundation", ""

      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-macos-target=#{MacOS.version}
        --enable-64bit
      ]
      system "./configure", *args
      # Remove the broken (for anyone but Firefox) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ " if OS.mac?

      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end

  test do
    system "#{bin}/nspr-config", "--version"
  end
end
