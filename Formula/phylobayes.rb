class Phylobayes < Formula
  # cite Lartillot_2009: "https://doi.org/10.1093/bioinformatics/btp368"
  desc "Phylogenetic reconstruction using infinite mixtures"
  homepage "http://megasun.bch.umontreal.ca/People/lartillot/www/download.html"
  url "https://github.com/bayesiancook/phylobayes/archive/v4.1e.tar.gz"
  version "4.1e"
  sha256 "ab88c65844db76f3229a088825153b04c1ce59f129805ddb75a7728920b31304"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    sha256 "00090e9eaaa15b0c9550e2cf07eecfff768bfac168c96454c55aa1f0854b99c1" => :catalina
    sha256 "5d169434d26e6cf4569bddefe6fddb35086850b3b68f74f96ff766fb250366ed" => :x86_64_linux
  end

  conflicts_with "phylobayes-mpi"

  def install
    pkgshare.install Dir["data/*"]
    system "make", "-C", "sources"
    bin.install Dir["data/*"]
  end

  test do
    cp Dir[pkgshare/"brpo/*"], testpath
    system "#{bin}/pb", "-t", "brpo.tree", "-d", "brpo.ali", "-x", "1", "10", "test"
  end
end
