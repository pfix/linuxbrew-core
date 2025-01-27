class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  head "https://git.videolan.org/git/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://git.videolan.org/git/x264.git",
        :revision => "0a84d986e7020f8344f00752e3600b9769cc1e85"
    version "r2917"
  end

  bottle do
    cellar :any
    sha256 "ffa8c266ebaf05d45d7b50c73351cb3c5ea0c76fadd2bb421fc058f31bfc875f" => :catalina
    sha256 "474593a6930921e1668ff97daaa211d6b0da6c48a08f928496d76b45542afafe" => :mojave
    sha256 "0aad96ccfbf09fbb4cbbaa708c9ff6b46829bd92873f482b05582ee0f7389624" => :high_sierra
    sha256 "845455c25e8966fd2a1dc9c08b78df6c9a28d73848c187b411ef5d34de6094d0" => :sierra
    sha256 "663fb07d232760dedabaabdb206ee0892937d63b1b574e5b8aee4d0a83ff1219" => :x86_64_linux
  end

  depends_on "nasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L{lib}", "test.c", "-lx264", "-o", "test"
    system "./test"
  end
end
