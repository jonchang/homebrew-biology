class Treepl < Formula
  desc "dating phylogenies with penalized likelihood"
  homepage "http://blackrim.org/programs/treepl/"
  url "https://github.com/blackrim/treePL/archive/3ee6ab1b820c9171eb7c55f3519df3294900e049.tar.gz"
  sha256 "bc19cd534b8618bec63c6239be4377eea635534d8c301f2efa4d2f866adbd3f3"
  version "2016.11.19"
  head "https://github.com/blackrim/treePL.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nlopt"

  needs :openmp

  def install
    # Check for brewed adol-c
    adolc = Formula["adol-c"]
    if adolc.installed? and Keg.for(adolc.lib).linked?
      onoe "Please unlink Homebrew's ADOL-C before building treePL:"
      onoe "    brew unlink adol-c"
      onoe "    brew install treepl"
      odie "    brew link adol-c"
    end

    # Use the vendored copy of adol-c since Homebrew's version is too new
    cd "deps" do
      system "tar", "xf", "adol-c_git_saved.tar.gz"
      cd "adol-c" do
        system "autoreconf", "-fi"
        system "./configure", "--with-openmp-flag=-fopenmp", "--prefix=#{libexec}"
        system "make", "install"
      end
    end

    cd "src" do
      # Tell configure where to find libraries
      nlopt = Formula["nlopt"]
      ENV.prepend "CPPFLAGS", "-I#{libexec}/include"
      ENV.append "CPPFLAGS", "-I#{nlopt.include}"
      ENV.append "CFLAGS", "-I#{nlopt.include}"
      ENV.append "LDFLAGS", "-L#{nlopt.lib}"
      ENV.prepend "LDFLAGS", "-L#{libexec}/lib64"
      ENV.prepend "LDFLAGS", "-Wl,-rpath,/#{libexec}/lib64"

      system "./configure"
      system "make"
      bin.install "treePL"
    end

    pkgshare.install "examples"
  end

  def caveats; <<-EOS.undent
    If you encounter build problems and also have ADOL-C installed, unlink it
    before attempting to build treePL:

        brew unlink adol-c
        brew install treepl
        brew link adol-c

    Example files were installed to:
        #{opt_prefix}/share/treepl
    EOS
  end

  test do
    cp_r opt_pkgshare/"examples", testpath
    cd testpath/"examples" do
      system "#{bin}/treePL", "clock.cppr8s"
      system "#{bin}/treePL", "test.cppr8s"
    end
  end
end
