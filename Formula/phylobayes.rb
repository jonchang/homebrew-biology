class Phylobayes < Formula
  # cite Lartillot_2009: "https://doi.org/10.1093/bioinformatics/btp368"
  desc "Phylogenetic reconstruction using infinite mixtures"
  homepage "http://megasun.bch.umontreal.ca/People/lartillot/www/download.html"
  url "https://github.com/bayesiancook/phylobayes.git", :revision => "2d3a62c04b86eda28149a94a187580d59ecbff8d"
  version "4.1d"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    sha256 "9488c612b4be72bd5c1d00a993a88411f5ab22409c518ce0c67b0bac0ca3405d" => :catalina
    sha256 "c6c9b52153bfb8c7c49f2b94326a7187e3edf4ed56442af0045f9700ac843f67" => :x86_64_linux
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
