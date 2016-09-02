class Bucky < Formula
  desc "Bayesian concordance analysis of gene trees"
  homepage "http://www.stat.wisc.edu/~ane/bucky/"
  url "http://www.stat.wisc.edu/~ane/bucky/v1.4/bucky-1.4.4.tgz"
  sha256 "1621fee0d42314d9aa45d0082b358d4531e7d1d1a0089c807c1b21fbdc4e4592"
  head "http://www.stat.wisc.edu/~ane/bucky.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btq539"

  def install
    cd "src" do
      system "make"
      bin.install "mbsum", "bucky"
    end
    pkgshare.install ["data", "scripts", "doc"]
  end

  def caveats
    <<-EOS.undent
      The manual, examples, and scripts are installed to:
          #{pkgshare}
    EOS
  end

  test do
    system "bucky", "--version"
  end
end
