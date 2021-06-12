class Tact < Formula
  include Language::Python::Virtualenv

  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.3.4.tar.gz"
  sha256 "20f70e893a1560e6f57b9dddd6b49bdf7abe45e9770dc48a088e1bf10c01791c"
  revision 1

  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "scipy"

  resource "DendroPy" do
    url "https://files.pythonhosted.org/packages/e0/f3/222e939e250e71234031d182e58704fff1c3296140f91f70d7ef8b3e17a6/DendroPy-4.5.1.tar.gz"
    sha256 "3503b170ba4830239dfa93371d210367a3be5825c3cb23ad7504a0feb3be7dbe"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "poetry_core" do
    url "https://files.pythonhosted.org/packages/42/21/5335c7eceff3dccb3b415018bb17db0c442b599f610fd5712021d5f9403f/poetry-core-1.0.0.tar.gz"
    sha256 "6a664ff389b9f45382536f8fa1611a0cb4d2de7c5a5c885db1f0c600cd11fbd5"
  end

  def install
    virtualenv_install_with_resources
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
