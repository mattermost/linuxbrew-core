class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.0.9-14.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-7.0.9-14.tar.xz"
  sha256 "5c45ff1101f0c58a0ca4487959f95c57283638997ac48875c91682ef0432b2e5"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "7914bafe42d346fed256748a36eb249601689c0cd1407297cfc33682f4d29a8c" => :catalina
    sha256 "79fb6d07daffc64759c6456b9a47f0b279876a78312bca29eb3eac88f8df12e9" => :mojave
    sha256 "9292392034c82d3fe6382ce1670deef7bb6fdc4f730ac402f96c12660a6e122d" => :high_sierra
    sha256 "2c5e7d615ff74e09c9802f930ed4c4c1c37ed4e0b227c063c1366c594aa3d718" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-openjp2
      --with-openexr
      --with-webp=yes
      --with-heic=yes
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
      --enable-openmp
      ac_cv_prog_c_openmp=-Xpreprocessor\ -fopenmp
      ac_cv_prog_cxx_openmp=-Xpreprocessor\ -fopenmp
      LDFLAGS=-lomp
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
