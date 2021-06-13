class Examl < Formula
  # cite Kozlov_2015: "https://doi.org/10.1093/bioinformatics/btv184"
  desc "Exascale maximum likelihood phylogenetic inference"
  homepage "https://cme.h-its.org/exelixis/web/software/examl/index.html"
  url "https://github.com/stamatak/ExaML/archive/v3.0.22.tar.gz"
  sha256 "802e673b0c2ea83fdbe6b060048d83f22b6978933a04be64fb9b4334fe318ca3"
  head "https://github.com/stamatak/ExaML.git"

  bottle do
    root_url "https://ghcr.io/v2/jonchang/biology"
    rebuild 1
    sha256 cellar: :any,                 catalina:     "12ee8f3b9c2d424cdf30c5f0c46372c8287dce5c33c87b6ff0a95186b9e37a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "624e89db9309eef2e373856bc1626ad3f70e1991bb46a666e346ce969f2abee0"
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
    assert_predicate testpath/"ExaML_result.T1", :exist?
  end
end
