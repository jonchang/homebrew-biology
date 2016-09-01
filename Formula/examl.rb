require 'formula'

class Examl < Formula
  homepage 'http://sco.h-its.org/exelixis/web/software/examl/index.html'
  head 'https://github.com/stamatak/ExaML.git'

  depends_on :mpi

  def install
    cd "parser" do
      system "make", "-f", "Makefile.SSE3.gcc"
      bin.install "parser"
    end
    cd "examl" do
      system "make", "-f", "Makefile.SSE3.gcc"
      (rm Dir["*.o"] and system "make", "-f", "Makefile.AVX.gcc") if Hardware::CPU.avx?
      bin.install Dir["examl*"]
    end
    share.install "manual", "testData"
  end

  def caveats; <<-EOS.undent
    Documentation and example data have been installed to:
      #{share}
    EOS
  end
end
