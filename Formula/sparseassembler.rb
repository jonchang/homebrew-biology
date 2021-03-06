class Sparseassembler < Formula
  # cite Ye_2012: "https://doi.org/10.1186/1471-2105-13-S6-S1"
  desc "Sparse k-mer graph based memory-efficient genome assembler"
  homepage "https://sites.google.com/site/sparseassembler/"
  url "https://github.com/yechengxi/SparseAssembler.git", revision: "3f802de4862c736b7f0855eff62ca1439b0eb86e"
  version "20180622"

  resource "testdata" do
    url "https://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    system ENV.cxx, "SparseAssembler.cpp", "-o", "SparseAssembler"
    bin.install "SparseAssembler"
  end

  test do
    testpath.install resource("testdata")
    args = %w[g 10 k 51 LD 0 GS 200000000 NodeCovTh 1 EdgeCovTh 0 p2 reads1.fastq p2 reads2.fastq]
    system "#{bin}/SparseAssembler", *args
  end
end
