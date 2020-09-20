class Tact < Formula
  include Language::Python::Virtualenv

  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.3.2.tar.gz"
  sha256 "32f053e916b743a9174783cc04bcab376b320d6bd6d06474241e5489bf45aabb"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    sha256 "13e1a0a0442296c70fd0ec5739f4e7c5571d2f801263033a2e70273bad7f4293" => :catalina
    sha256 "5b60b0801a3daa6fa3d7d0df4d8d66be6758e4fdc21316b9f09a147d94db862c" => :x86_64_linux
  end

  depends_on "numpy"
  depends_on "python@3.8"
  depends_on "scipy"

  resource "DendroPy" do
    url "https://files.pythonhosted.org/packages/f5/21/17e4fbb1c2a68421eec43930b1e118660c7483229f1b28ba4402e8856884/DendroPy-4.4.0.tar.gz"
    sha256 "f0a0e2ce78b3ed213d6c1791332d57778b7f63d602430c1548a5d822acf2799c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "poetry_core" do
    url "https://files.pythonhosted.org/packages/1b/47/3f770be8226e0e34d40dbe42e19076c793194ea936163c9fb1c79e9510f5/poetry-core-1.0.0a8.tar.gz"
    sha256 "02237e5abaa4fda4ef865cc49111a3f8a7999cfb149b30d5e93f85c3acdc4d95"
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
