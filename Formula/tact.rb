class Tact < Formula
  include Language::Python::Virtualenv

  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.4.1.tar.gz"
  sha256 "c4493d137b1503c6f1ac40aae13407e11bd62cedc84c6659dabdc030dae753bd"

  bottle do
    root_url "https://ghcr.io/v2/jonchang/biology"
    sha256 cellar: :any_skip_relocation, catalina:     "5a43b66e1f939e548b416edd6d9b5a5cae0588eeba7ddd7d66b9b69d52f4110e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "154484593ffcb6b459f30ff28dc89416bca4bb0b32f4090756000dceaf7560a3"
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
