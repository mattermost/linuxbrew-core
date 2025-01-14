class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.4.2",
      :revision => "35eb9dc7c6e78dac5bd8c3d142bc2a4601616932"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5666f84effa22938666cd051b98f4a36e2fbe4521bce3c77ee5e2125b4ee836" => :catalina
    sha256 "f5666f84effa22938666cd051b98f4a36e2fbe4521bce3c77ee5e2125b4ee836" => :mojave
    sha256 "f5666f84effa22938666cd051b98f4a36e2fbe4521bce3c77ee5e2125b4ee836" => :high_sierra
    sha256 "c5f078ac9c1bcf58f97ac717366e1f5c7ec6a48160adfe73dc7f45c3c9fa059b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"

    srcpath = buildpath/"src/istio.io/istio"
    if OS.mac?
      outpath = buildpath/"out/darwin_amd64/release"
    else
      outpath = buildpath/"out/linux_amd64/release"
    end
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
