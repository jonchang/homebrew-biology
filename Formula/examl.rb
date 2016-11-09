class Examl < Formula
  desc "Exascale maximum likelihood phylogenetic inference"
  homepage "http://sco.h-its.org/exelixis/web/software/examl/index.html"
  url "https://github.com/stamatak/ExaML/archive/v3.0.17.tar.gz"
  sha256 "90a859e0b8fff697722352253e748f03c57b78ec5fbc1ae72f7e702d299dac67"
  head "https://github.com/stamatak/ExaML.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btv184"

  depends_on :mpi => :cc

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

  def caveats; <<-EOS.undent
    Documentation and example data have been installed to:
      #{pkgshare}
    EOS
  end

  test do
    cp pkgshare/"testData/49", testpath
    cp pkgshare/"testData/49.tree", testpath
    system "#{bin}/parse-examl", "-s", "49", "-m", "DNA", "-n", "49"
    system "#{bin}/examl", "-t", "49.tree", "-m", "GAMMA", "-s", "49.binary", "-n", "T1"
    assert File.exist? "ExaML_result.T1"
  end
end
