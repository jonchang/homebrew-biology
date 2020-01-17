class Bucky < Formula
  # cite Larget_2010: "https://doi.org/10.1093/bioinformatics/btq539"
  desc "Bayesian concordance analysis of gene trees"
  homepage "http://www.stat.wisc.edu/~ane/bucky/"
  url "http://www.stat.wisc.edu/~ane/bucky/v1.4/bucky-1.4.4.tgz"
  sha256 "1621fee0d42314d9aa45d0082b358d4531e7d1d1a0089c807c1b21fbdc4e4592"
  head "https://github.com/jonchang/bucky.git"

  def install
    cd "src" do
      system "make"
      bin.install "mbsum", "bucky"
    end
    pkgshare.install ["data", "scripts", "doc"]
  end

  test do
    system "#{bin}/bucky", "--version"
  end
end
