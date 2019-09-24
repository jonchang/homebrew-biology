class Tact < Formula
  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.1.2.tar.gz"
  sha256 "965fca53027c3f03826ad6237b9de65b9659ee2c0ca930ebbce6d5639f806f91"
  revision 3

  depends_on "pipx" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  def install
    ENV["PIPX_HOME"] = libexec
    ENV["PIPX_BIN_DIR"] = bin
    system "pipx", "install", "tact", "--verbose"
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
