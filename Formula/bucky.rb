class Bucky < Formula
  # cite Larget_2010: "https://doi.org/10.1093/bioinformatics/btq539"
  desc "Bayesian concordance analysis of gene trees"
  homepage "http://www.stat.wisc.edu/~ane/bucky/"
  url "http://www.stat.wisc.edu/~ane/bucky/v1.4/bucky-1.4.4.tgz"
  sha256 "1621fee0d42314d9aa45d0082b358d4531e7d1d1a0089c807c1b21fbdc4e4592"
  head "https://github.com/jonchang/bucky.git"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    sha256 "17ddd62791d2ddf08f77707d73800a5b06fea32ace204dd83042acb29606e9da" => :catalina
    sha256 "5f7b2a1a40f3b089b0c8834ff8fffa3af10c4ce0350c5721b04ae8b267198fb5" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make"
      bin.install "mbsum", "bucky"
    end
    pkgshare.install %w[data scripts doc]
  end

  test do
    system "#{bin}/bucky", "--version"
  end
end
