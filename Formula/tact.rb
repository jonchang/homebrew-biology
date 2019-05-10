class Tact < Formula
  include Language::Python::Virtualenv

  desc "Taxonomic addition for complete phylogenies"
  homepage "https://github.com/jonchang/tact"
  url "https://github.com/jonchang/tact/archive/v0.1.2.tar.gz"
  sha256 "965fca53027c3f03826ad6237b9de65b9659ee2c0ca930ebbce6d5639f806f91"
  revision 2

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any
    sha256 "a6842a4e2a4d44c29f045f172c23cc6d9f2204da03f00142b554786c9ac2d1ad" => :mojave
    sha256 "16846d19837e041725af624437ea6af0c19649b90ce6ccd3a86ccc566e20933b" => :x86_64_linux
  end

  if OS.mac?
    depends_on "pypy3" => :build
  else
    depends_on "python@3"
    depends_on "numpy" => :build
    depends_on "scipy" => :build
  end
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

  if OS.mac?
    resource "numpy" do
      url "https://files.pythonhosted.org/packages/source/n/numpy/numpy-1.16.2.zip"
      sha256 "6c692e3879dde0b67a9dc78f9bfb6f61c666b4562fd8619632d7043fb5b691b0"
    end

    resource "scipy" do
      url "https://files.pythonhosted.org/packages/source/s/scipy/scipy-1.2.1.tar.gz"
      sha256 "e085d1babcb419bbe58e2e805ac61924dac4ca45a07c9fa081144739e500aa3c"
    end
  end

  def install
    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      python = "pypy3"
    else
      python = "python3"
    end

    virtualenv_install_with_resources(:using => python)

    if OS.linux?
      %w[numpy scipy].map do |f|
        site = Language::Python.site_packages(python)
        pkg = Dir[Formula[f].prefix/site/"*"]
        cp_r pkg, libexec/site
      end
    else
      # Fix up dylibs for macOS
      dylib = (Formula["pypy3"].libexec)/"lib/libpypy3-c.dylib"
      mkdir libexec/"lib"
      cp dylib, libexec/"lib"
      %w[pypy pypy3].each do |binary|
        macho = MachO.open("#{libexec}/bin/#{binary}")
        wanted = macho.linked_dylibs.select { |dylib| dylib.end_with? "libpypy3-c.dylib" }
        macho.change_dylib(wanted.pop, "#{libexec}/lib/libpypy3-c.dylib")
        macho.write!
      end
    end

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
