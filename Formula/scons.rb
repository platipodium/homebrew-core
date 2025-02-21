class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/c6/63/3a87df61a5d8e1b2ba116f4889f3dbc2717ebe2e34c77b2d34e4e6b9deef/SCons-4.4.0.tar.gz"
  sha256 "7703c4e9d2200b4854a31800c1dbd4587e1fa86e75f58795c740bcfa7eca7eaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e49979efbc0d53d0ad0ab5dda8c0aaf4b827c2ecbffd4459fecdd86673500ed2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e53074519b96a32b1359d58664b934fc9cdaac37e1a414d2e7d43963e8f4c3a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e53074519b96a32b1359d58664b934fc9cdaac37e1a414d2e7d43963e8f4c3a0"
    sha256 cellar: :any_skip_relocation, ventura:        "428e5de3c453df16fb53f05bceaf33a14d7c790e6596e241de47dbebbb8da9c6"
    sha256 cellar: :any_skip_relocation, monterey:       "f4b2dc4152373424f8df6f9d8fff6e23e231443bd8897128445318468f23753d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4b2dc4152373424f8df6f9d8fff6e23e231443bd8897128445318468f23753d"
    sha256 cellar: :any_skip_relocation, catalina:       "f4b2dc4152373424f8df6f9d8fff6e23e231443bd8897128445318468f23753d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5596a34b3b95363298beae17d4ff46a6c7056c912d9f4181b4f86ea302a3d4e3"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
