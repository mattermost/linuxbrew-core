class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.4/vips-8.8.4.tar.gz"
  sha256 "9f7ae87814d990b67913ae69dc5f26fe62719e29aa7e6cc8908066f31ee15a35"
  revision 1

  bottle do
    sha256 "bc081a7d00a0447ffc0a6033eabeef9462e9f2206d0138963293d12f78408efd" => :catalina
    sha256 "11eb8e9e6f5700951c2d4137d22e4a94a711359bb4fc18321860be17cec947fb" => :mojave
    sha256 "d8e1a410d9f85bbda7c8aa878541f1637d215c07ed177c199857b5fc256e31c4" => :high_sierra
    sha256 "9f4ad52d609a2c5e8baa6ed4d9a6e599af2a7531a24def8d2c8295afcd98132d" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libheif"
  depends_on "libmatio"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "mozjpeg"
  depends_on "openexr"
  depends_on "openslide"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"
  uses_from_macos "curl"
  depends_on "gobject-introspection" unless OS.mac?

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib/"pkgconfig"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-magick
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp

    # --trellis-quant requires mozjpeg, vips warns if it's not present
    cmd = "#{bin}/vips jpegsave #{test_fixtures("test.png")} #{testpath}/test.jpg --trellis-quant 2>&1"
    assert_equal "", shell_output(cmd)
  end
end
