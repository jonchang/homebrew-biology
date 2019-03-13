class Tact < Formula
  include Language::Python::Virtualenv

  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.1.2.tar.gz"
  sha256 "965fca53027c3f03826ad6237b9de65b9659ee2c0ca930ebbce6d5639f806f91"

  bottle do
    root_url "https://dl.bintray.com/jonchang/biology-bottles"
    cellar :any
    sha256 "19972ca0bff0f0de05b7f9550f7298292a513b31d5a3cdbb95e23ce5ec0e17df" => :mojave
  end

  depends_on "pypy3" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "click" do
    url "https://files.pythonhosted.org/packages/source/c/click/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "DendroPy" do
    url "https://files.pythonhosted.org/packages/source/D/DendroPy/DendroPy-4.4.0.tar.gz"
    sha256 "f0a0e2ce78b3ed213d6c1791332d57778b7f63d602430c1548a5d822acf2799c"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/source/n/numpy/numpy-1.16.2.zip"
    sha256 "6c692e3879dde0b67a9dc78f9bfb6f61c666b4562fd8619632d7043fb5b691b0"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/source/s/scipy/scipy-1.2.1.tar.gz"
    sha256 "e085d1babcb419bbe58e2e805ac61924dac4ca45a07c9fa081144739e500aa3c"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?
    virtualenv_install_with_resources
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/*", testpath
    ENV["LANG"] = ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/tact_build_taxonomic_tree", "Carangaria.csv", "--output=tax.tre"
    system "#{bin}/tact_add_taxa", "--backbone=Carangaria.tre", "--taxonomy=tax.tre", "--output=tact"
    system "#{bin}/tact_check_results", "tact.newick.tre", "--backbone=Carangaria.tre", "--taxonomy=tax.tre"
  end
end
