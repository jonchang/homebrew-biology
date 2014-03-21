require "formula"

class Phylocom < Formula
  homepage "http://phylodiversity.net/phylocom/"
  url "http://phylodiversity.net/phylocom/phylocom-4.2.zip"
  sha1 "e50453ba728c470e89f00abe857a8a05c083691c"
  head "https://github.com/phylocom/phylocom.git"

  def install
    cd "src" do
      system "make"
      bin.install "phylocom", "ecovolve", "phylomatic"
    end
    share.install "example_data", "tools"
  end

  def caveats; <<-EOS.undent
  Example data and misc. tools have been installed to:
    #{share}
  EOS
  end
end
