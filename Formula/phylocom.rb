class Phylocom < Formula
  desc "Phylogenetic community structure and character evolution"
  homepage "http://phylodiversity.net/phylocom/"
  url "https://github.com/phylocom/phylocom/releases/download/4.2/phylocom-4.2.zip"
  sha256 "f4f111adedfc91f2316b08ec5a994da83888bb1c0acd6076083112a5f51583c7"
  head "https://github.com/phylocom/phylocom.git"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    sha256 "ded32f4876f63cc84dc39c3ff97e2228ac1b27aacb4fb9187835182409a41df7" => :catalina
    sha256 "6fefbc1aa15381b61f15050ee8d6ca120cf8e59c13e065667843cc02c440f027" => :x86_64_linux
  end

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
