class Tact < Formula
  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.2.1.tar.gz"
  sha256 "03c3cabb3e8889d81f1a3dbc50f3f4507a4399f0142dce00ddcfc13a8219dc72"
  revision 1

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any
    sha256 "2f191bc53a0e70a0efc7174bc5e6a20f19db34126665b7296e2b638e25732428" => :catalina
    sha256 "f3c5f12e958762493f228daeac9dc5564a3c3aa322f99d9c6d733cedda8a728f" => :x86_64_linux
  end

  depends_on "pipx" => :build
  depends_on "gcc" # for gfortran
  depends_on "python"

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
