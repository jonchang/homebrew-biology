class Nquire < Formula
  # cite Weiss_2018: "https://doi.org/10.1186/s12859-018-2128-z"
  desc "Ploidy estimation using NGS short-read data"
  homepage "https://github.com/clwgg/nQuire"
  url "https://github.com/clwgg/nQuire/archive/a990a88ef14b38f257f1a0d368ba8be1bd3d7e4b.zip"
  sha256 "0e768896a9e700205249b4c330b0923f51d9d4d5c032743cad78f52fd80c9da5"
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
