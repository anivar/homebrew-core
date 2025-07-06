class DotfilesPlus < Formula
  desc "AI-powered terminal productivity suite"
  homepage "https://github.com/anivar/dotfiles-plus"
  url "https://github.com/anivar/dotfiles-plus/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "f3ba15e86b02de92fbd0d8edb31afe815677012da4234ec7a08aa2ef17f0513d"
  license "MIT"

  depends_on "bash"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"install.sh" => "dotfiles-plus"
  end

  test do
    assert_predicate libexec/"install.sh", :exist?
    assert_predicate libexec/"dotfiles-plus.sh", :exist?
    assert_predicate libexec/"VERSION", :exist?
  end
end