class Eems < Formula
  desc "Estimating Effective Migration Surfaces"
  homepage "https://github.com/dipetkov/eems"
  url "https://github.com/dipetkov/eems.git", revision: "34ebbb64919db368a6d857476b2097e7578d9da0"
  version "2023.10.28"
  head stable.url

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  resource "libplinkio" do
    url "https://github.com/mfranberg/libplinkio/archive/refs/tags/v0.9.8.tar.gz"
    sha256 "de54dd4789b2da9b937a1f445dc6976153211dc35b4376a4cf561ad2ee861075"
  end

  def install
    # Build libplinkio, needed for bed2diffs_v*
    resource("libplinkio").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Set up Make variables
    boost = Formula["boost"]
    makevars = %W[BOOST_LIB=#{boost.opt_lib}
                  BOOST_INC=#{boost.opt_include}
                  EIGEN_INC=#{Formula["eigen"].opt_include}/eigen3
                  PLINKIO=#{libexec}]
    target = OS.mac? ? "darwin" : "linux"

    cd "bed2diffs" do
      # libplinkio doesn't seem to support gcc-based builds on macOS
      src = OS.mac? ? "src-wout-openmp" : "src"
      cd src do
        # Fix incorrect include location
        cxxflags = "CXXFLAGS=-I${PLINKIO}/include -O3"
        cxxflags += " -fopenmp" unless OS.mac?
        system "make", target, *makevars, cxxflags
        # Because it's too difficult to just define both in one Makefile...
        inreplace "Makefile", "bed2diffs_v1", "bed2diffs_v2"
        system "make", target, *makevars, cxxflags
        bin.install Dir["bed2diffs_v{1,2}"]
      end
    end

    cd "runeems_sats" do
      cd "src" do
        system "make", target, *makevars
        bin.install "runeems_sats"
      end
      (pkgshare/"sats").install Dir["data/*"]
    end

    cd "runeems_snps" do
      cd "src" do
        system "make", target, *makevars
        bin.install "runeems_snps"
      end
      (pkgshare/"snps").install Dir["data/*"]
    end
  end

  test do
    cp Dir["#{pkgshare}/snps/barrier-schemeZ-nIndiv300-nSites3000*"], testpath
    (testpath/"params.ini").write <<~EOS
      datapath = ./barrier-schemeZ-nIndiv300-nSites3000
      mcmcpath = chain1
      nIndiv = 300
      nSites = 3000
      nDemes = 200
      diploid = false
      numMCMCIter = 1000
      numBurnIter = 10
      numThinIter = 10
    EOS
    system "#{bin}/runeems_snps", "--params", "params.ini"
  end
end
