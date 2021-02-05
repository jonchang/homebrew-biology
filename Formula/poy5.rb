class Poy5 < Formula
  desc "Phylogenetic Application written in OCaml and C"
  homepage "https://www.amnh.org/research/computational-sciences/poy"
  url "https://github.com/amnh/poy5.git", revision: "da563a2339d3fa9c0110ae86cc35fad576f728ab"
  version "2020.29.01"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    sha256 cellar: :any_skip_relocation, catalina:     "ba6c6f5238f00d517ccc815dd61c5e7219d4a1877a338ecb65a0e4ab382542a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c94e7b16afe2dc77a0c2e908d9d130b4a621d2f5df65909c30bc3fd5f67504d4"
  end

  disable! because: "camlp4 is gone"

  depends_on "camlp5" => :build
  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "openblas" if OS.linux?
  depends_on "readline" if OS.linux?
  uses_from_macos "zlib"

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}",
                            "--enable-interface=readline"
      system "make", "OCAMLPARAM=safe-string=0,_"
      system "make", "install"
    end
  end

  test do
    system "poy", "-help"
  end
end
