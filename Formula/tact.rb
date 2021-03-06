class Tact < Formula
  include Language::Python::Virtualenv

  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.4.0.tar.gz"
  sha256 "d33b3094c79e7a07f8c7b77e8bf1e95b014465c1ef8ef77ca93b931b8d6e4d07"

  bottle do
    root_url "https://ghcr.io/v2/jonchang/biology"
    sha256 cellar: :any_skip_relocation, catalina:     "44b54671f6fb822669b4fcff858c31754606c00160b836054e1eef0395ce76e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "995f73b8537d1c4238f9b9911ac7b316e5617fa76ea9feaff0e891e7f5323c8e"
  end

  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "scipy"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "DendroPy" do
    url "https://files.pythonhosted.org/packages/f9/10/125c181b1d97ffc4661a60ec897cfe058dc46cb53900d807819464c3510f/DendroPy-4.5.2.tar.gz"
    sha256 "3e5d2522170058ebc8d1ee63a7f2d25b915e34957dc02693ebfdc15f347a0101"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/d0/b3/1017f2f6d801f1e3e4ffee3f058a10d20df1a9560aba9c5b49e92cdd9912/poetry-core-1.0.3.tar.gz"
    sha256 "2315c928249fc3207801a81868b64c66273077b26c8d8da465dccf8f488c90c5"
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
