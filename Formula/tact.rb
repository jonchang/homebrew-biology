class Tact < Formula
  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.2.3.tar.gz"
  sha256 "915a3e3cd4a88adb5d895e10633f9ba71b681ecf49cc1d5e7f0a92c7b1e39c92"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any
    sha256 "96bf45cb3bd8b372498972ab43e1b35bc86e5b48b18e6991de079ad3e8e73a5a" => :catalina
    sha256 "a85adde8eebf6c939f85fce604f73f217df404ca2ec3cf42ca8288f69a669e52" => :x86_64_linux
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
