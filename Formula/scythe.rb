class Scythe < Formula
  desc "Bayesian adapter trimmer"
  homepage "https://github.com/vsbuffalo/scythe"
  url "https://github.com/vsbuffalo/scythe.git",
      :revision => "20d3cff7d7f483bd779aff75f861e93708c0a2b5"
  version "0.994"
  head "https://github.com/vsbuffalo/scythe.git"
  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    sha256 "be1d2171aaed9f971175d104558546ad398acf44846ec00a08ce65fc44019ebb" => :catalina
    sha256 "738d10646a49bcea042e37b33e6a1bb8eaf9652097eb749b153bfa81ae8950a7" => :x86_64_linux
  end

  # tag "bioinformatics"

  def install
    system "make", "all"
    bin.install "scythe"
    pkgshare.install "testing"
  end

  test do
    cp pkgshare/"testing/btrim_adapters.fa", testpath
    cp pkgshare/"testing/reads.fastq", testpath
    system "#{bin}/scythe", "-a", "btrim_adapters.fa", "-o", "trimmed.fa", "reads.fastq"
  end
end
