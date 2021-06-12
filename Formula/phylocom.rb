class Phylocom < Formula
  desc "Phylogenetic community structure and character evolution"
  homepage "http://phylodiversity.net/phylocom/"
  url "https://github.com/phylocom/phylocom/releases/download/4.2/phylocom-4.2.zip"
  sha256 "f4f111adedfc91f2316b08ec5a994da83888bb1c0acd6076083112a5f51583c7"
  head "https://github.com/phylocom/phylocom.git"

  def install
    cd "src" do
      system "make"
      bin.install "phylocom", "ecovolve", "phylomatic"
    end
    pkgshare.install "example_data", "phylocom_manual.pdf"
  end

  test do
    cp pkgshare/"example_data/phylo", testpath
    cp pkgshare/"example_data/sample", testpath
    msg = "Phylocom output: randomization method 2, 999 runs"
    assert_match msg, shell_output("#{bin}/phylocom comstruct", 1)
  end
end
