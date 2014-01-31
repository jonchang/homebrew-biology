require 'formula'

class Raxml < Formula
  homepage 'http://sco.h-its.org/exelixis/software.html'
  head 'https://github.com/stamatak/standard-RAxML.git'

  def install
    system "make", "-f", "Makefile.SSE3.PTHREADS.gcc"
    bin.install "raxmlHPC-PTHREADS-SSE3"
  end

  def test
    system "raxmlHPC-PTHREADS-SSE3", "-v"
  end
end
