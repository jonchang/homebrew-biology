class Tact < Formula
  include Language::Python::Virtualenv

  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.1.0.tar.gz"
  sha256 "fce8d692d120673d05d4d9a2b9595b6b84bf1bf74dc89a030abdf30df6ef62fe"

  depends_on "gcc" # for gfortran
  depends_on "openblas"
  depends_on "pypy3"

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
  end

  test do
    cmds = %w[add_taxa build_taxonomic_tree check_results]
    cmds.each do |cmd|
      system "#{bin}/tact_#{cmd}", "--help"
    end
  end
end
