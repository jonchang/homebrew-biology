class Tact < Formula
  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.2.2.tar.gz"
  sha256 "dbeb749aecdd511ba9e5543abd5dd1807c67d034d1efef9ac142b7991a9b6b49"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    sha256 "eff2eac73114a664a61e1a5e648d73011ccaf00c6a983bf6c2ffe985cfbf2e2f" => :catalina
    sha256 "d28568c366fd6326f6e32802e3c36f95785bc9a228194daed40019d77fabb7c8" => :x86_64_linux
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
