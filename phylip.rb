require 'formula'

class Phylip < Formula
  homepage 'http://evolution.genetics.washington.edu/phylip.html'
  url 'http://evolution.gs.washington.edu/phylip/download/phylip-3.69.tar.gz'
  sha1 'ada364d1a588935ff59a23c08337d9dd99109c5e'

  depends_on :x11

  def install
    system "cd src;make all;make put EXEDIR=#{bin}"
    bin.cd do
      rm Dir['font*'] # Remove installed fonts
    end
  end
end
