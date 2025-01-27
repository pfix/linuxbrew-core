class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.6.1.tar.xz"
  sha256 "c651fb3faaa338aeb280726837c2384064cdc17ef40539228d88a1260960844f"

  bottle do
    cellar :any
    sha256 "ca99028cc06b248c8a5993efea6e5e956dcdb261a4c3c78c9c0996b21fa007d3" => :catalina
    sha256 "e413fa2b3eca6c721c53d95c4fb1917ab1f1d8f3a9dec1a004cce498856cedf8" => :mojave
    sha256 "965e727a00d95872555bddab546a684a5cfec72879f44d2e89d55442fd9b9e73" => :high_sierra
    sha256 "ea2c08348b1f5c929c30918a90fa1688eab618c689c53ab244f0e4b8bbd129e3" => :sierra
    sha256 "a38111d99206a32516c339b61f3da5635468d14c0bd723a74031168a89dc49a2" => :x86_64_linux
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "ragel" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=yes
      --enable-static
      --with-cairo=yes
      --with-coretext=#{OS.mac? ? "yes" : "no"}
      --with-freetype=yes
      --with-glib=yes
      --with-gobject=yes
      --with-graphite2=yes
      --with-icu=yes
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
