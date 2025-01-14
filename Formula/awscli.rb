class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.16.310.tar.gz"
  sha256 "2a8fa13b03714fd1f503b2c4a696c5cf433a2bc07ea5d262387a2f176e8f535e"
  revision 1
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9325b1008a86a6c4c5f4b66306fdd0253567a4128fec9b42feb8b1003654c837" => :catalina
    sha256 "782e0766a5ca96f93bdde03d11ac170d953b2e29de584ac83c8c3f48520432f5" => :mojave
    sha256 "cf906177afd0ac1a49b256c6a5a4c7afcd012183ccd9db96dd85beb96283a228" => :high_sierra
    sha256 "484a3b265471c89b8e0f4afe30f1968f66bffe991beb23ffcff9197b8c22ce9b" => :x86_64_linux
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.8"

  uses_from_macos "libyaml"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats; <<~EOS
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
  EOS
  end

  test do
    if OS.mac?
      assert_match "topics", shell_output("#{bin}/aws help")
    else
      # aws-cli needs groff as dependency, which we do not want to install
      # just to display the help.
      system "#{bin}/aws", "--version"
    end
  end
end
