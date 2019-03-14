class Revbayes < Formula
  # cite Hohna_2016: "https://doi.org/10.1093/sysbio/syw021"
  desc "Bayesian phylogenetic inference with graphical models"
  homepage "https://revbayes.github.io/"
  url "https://github.com/revbayes/revbayes/archive/v1.0.10.tar.gz"
  sha256 "95e9affe8ca8d62880cf46778b6ec9dd8726e62a185670ebcbadf2eb2bb79f93"
  head "https://github.com/revbayes/revbayes.git", :branch => "development"

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "open-mpi"

  def install
    cd "projects/cmake" do
      inreplace "regenerate.sh", /^SET.*BOOST_ROOT.*$/, ""
      mkdir "build"
      system "./regenerate.sh", "-boost", "false"
      cd "build" do
        system "cmake", ".", *std_cmake_args
        system "make"
      end
      bin.install "rb"
    end
  end

  test do
    cp pkgshare/"examples/HKY.Rev", testpath
    cp pkgshare/"tests/data/Primates.nex", testpath
    mv "Primates.nex", "primates_cytb.nex"
    system "#{bin}/rb", "HKY.Rev"
  end
end
