class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/6.12.5.tar.gz"
  sha256 "7a2998b040fc98c3171a4d1c54778b6d8ea3252f84bb2cad4da8e9db1325746a"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dad80ffc1c5ffa91f6c0a94564f6462f66569c0990796b8b8e99dda36496a662"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.11"

  resource "homebrew-testdata" do
    url "https://github.com/oracle/graal/archive/refs/tags/vm-22.1.0.1.tar.gz"
    sha256 "7653558bc4e4a5f89e5ddef7242ddc1ec5582ec75bdc94997feb76ed12ce8e94"
  end

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.11"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"
  end

  def post_install
    # Run a simple `mx` command to create required empty directories inside libexec
    Dir.mktmpdir do |tmpdir|
      system bin/"mx", "--user-home", tmpdir, "version"
    end
  end

  test do
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["MX_ALT_OUTPUT_ROOT"] = testpath

    testpath.install resource("homebrew-testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end
