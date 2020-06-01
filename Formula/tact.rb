class Tact < Formula
  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.2.4.tar.gz"
  sha256 "ec78f2c82e372aef23abd7104465a8684f7060ffbf67fa8bdafa7019645c27bc"
  revision 1

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1a1e256f406b9b385e95f9b30e2bc82f48b096c0c7e8bbc451f9bba2fc5b1f9a" => :catalina
    sha256 "0d2d2483b704fffd26159b86a791b135d38ed7dac0bd54e7de137ce730ee1da8" => :x86_64_linux
  end

  depends_on "pipx" => :build
  depends_on "gcc" # for gfortran
  depends_on "python@3.8"

  def install
    ENV["PIPX_HOME"] = libexec
    ENV["PIPX_BIN_DIR"] = bin
    system "pipx", "install", "--verbose", "--pip-args=--ignore-installed", "tact"
    pkgshare.install "examples"
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    ENV["LANG"] = ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/tact_build_taxonomic_tree", "Carangaria.csv", "--output=tax.tre"
    system "#{bin}/tact_add_taxa", "--backbone=Carangaria.tre", "--taxonomy=tax.tre", "--output=tact"
    system "#{bin}/tact_check_results", "tact.newick.tre", "--backbone=Carangaria.tre", "--taxonomy=tax.tre"
  end
end
