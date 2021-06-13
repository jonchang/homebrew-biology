class Bucky < Formula
  # cite Larget_2010: "https://doi.org/10.1093/bioinformatics/btq539"
  desc "Bayesian concordance analysis of gene trees"
  homepage "http://www.stat.wisc.edu/~ane/bucky/"
  url "http://www.stat.wisc.edu/~ane/bucky/v1.4/bucky-1.4.4.tgz"
  sha256 "1621fee0d42314d9aa45d0082b358d4531e7d1d1a0089c807c1b21fbdc4e4592"
  head "https://github.com/jonchang/bucky.git"

  bottle do
    root_url "https://ghcr.io/v2/jonchang/biology"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "8836f64c7629a6b4b1d912498a54ce925b8b776a181e16f89483ba54f4476902"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19dbd2a1544442545f82a69ccd778165ac241a62e5536f0dd4d9a9e91993181e"
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
