class Scythe < Formula
  desc "Bayesian adapter trimmer"
  homepage "https://github.com/vsbuffalo/scythe"
  url "https://github.com/vsbuffalo/scythe.git",
      :revision => "20d3cff7d7f483bd779aff75f861e93708c0a2b5"
  version "0.994"
  head "https://github.com/vsbuffalo/scythe.git"
  # tag "bioinformatics"

  def install
    system "make", "all"
    bin.install "scythe"
    pkgshare.install "testing"
  end

  def caveats; <<~EOS
  The example data have been installed to:
    #{pkgshare}
  EOS
  end

  test do
    cp pkgshare/"testing/btrim_adapters.fa", testpath
    cp pkgshare/"testing/reads.fastq", testpath
    system "#{bin}/scythe", "-a", "btrim_adapters.fa", "-o", "trimmed.fa", "reads.fastq"
  end
end
