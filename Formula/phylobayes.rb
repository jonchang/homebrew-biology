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
    sha256 "cc27449cfaa3daff36be843df8c58e94ce962026c6c5eb48b815ea6e70b51c79" => :catalina
    sha256 "ed13d98e3035effe097fd9a34eb188f7dff2ba1d36c84953fe03c6273527688c" => :x86_64_linux
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
