class Nquire < Formula
  # cite Weiss_2018: "https://doi.org/10.1186/s12859-018-2128-z"
  desc "Ploidy estimation using NGS short-read data"
  homepage "https://github.com/clwgg/nQuire"
  url "https://github.com/clwgg/nQuire.git", :revision => "a990a88ef14b38f257f1a0d368ba8be1bd3d7e4b"
  version "2018.5.4"
  head "https://github.com/clwgg/nQuire.git"

  depends_on "htslib"
  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "nQuire"
  end

  test do
    system "#{bin}/nQuire"
  end
end
