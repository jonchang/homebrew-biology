class Sparseassembler < Formula
  desc "Sparse k-mer graph based memory-efficient genome assembler"
  homepage "https://sites.google.com/site/sparseassembler/"
  url "https://github.com/yechengxi/SparseAssembler.git", :revision => "3f802de4862c736b7f0855eff62ca1439b0eb86e"
  version "20160205"

  resource("testdata") do
    url "http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    system ENV.cxx, "SparseAssembler.cpp", "-o", "SparseAssembler"
    bin.install "SparseAssembler"
  end

  test do
    testpath.install resource("testdata")
    raise
    system "false"
  end
end
