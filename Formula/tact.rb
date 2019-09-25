class Tact < Formula
  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.2.0.tar.gz"
  sha256 "2e595985cfafb23ba139f3f06c729b9240b05accbb38d6e146847189ab12cdd7"

  depends_on "pipx" => :build
  depends_on "gcc" # for gfortran
  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    # Because click is part of pipx we don't want to contaminate our
    # install with the version from Homebrew
    px = Formula["pipx"]
    click = Dir["#{px.libexec}/lib/python*/site-packages/click"].pop
    ENV["PIPX_HOME"] = libexec
    ENV["PIPX_BIN_DIR"] = bin
    system "pipx", "install", "--verbose", "--spec=.", "tact"
    cp_r click, libexec/"venvs/tact/lib/python#{xy}/site-packages"
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
