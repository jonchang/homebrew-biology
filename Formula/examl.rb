class Examl < Formula
  # cite Kozlov_2015: "https://doi.org/10.1093/bioinformatics/btv184"
  desc "Exascale maximum likelihood phylogenetic inference"
  homepage "http://sco.h-its.org/exelixis/web/software/examl/index.html"
  url "https://github.com/stamatak/ExaML/archive/v3.0.22.tar.gz"
  sha256 "802e673b0c2ea83fdbe6b060048d83f22b6978933a04be64fb9b4334fe318ca3"
  head "https://github.com/stamatak/ExaML.git"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    sha256 cellar: :any, catalina:     "b3629ff42edbe5777c9ff25ca65d109bc3ca395812a8e7e73f3390a854fa4d68"
    sha256 cellar: :any, x86_64_linux: "16d364c9fbd2bc40698cd5c5d4da10332f465f2a154a6bb6961450c32b48d350"
  end

  depends_on "open-mpi"

  def install
    cd "parser" do
      system "make", "-f", "Makefile.SSE3.gcc"
      bin.install "parse-examl"
    end

    cd "examl" do
      system "make", "-f", "Makefile.SSE3.gcc"
      if Hardware::CPU.avx?
        rm Dir["*.o"]
        system "make", "-f", "Makefile.AVX.gcc"
      end
      bin.install Dir["examl*"]
    end

    pkgshare.install "manual", "testData"
  end

  test do
    cp pkgshare/"testData/49", testpath
    cp pkgshare/"testData/49.tree", testpath
    system "#{bin}/parse-examl", "-s", "49", "-m", "DNA", "-n", "49"
    system "#{bin}/examl", "-t", "49.tree", "-m", "GAMMA", "-s", "49.binary", "-n", "T1"
    assert_predicate "ExaML_result.T1", :exist?
  end
end
