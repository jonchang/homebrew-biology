class Poy5 < Formula
  desc "Phylogenetic Application written in OCaml and C"
  homepage "https://www.amnh.org/research/computational-sciences/poy"
  url "https://github.com/amnh/poy5.git", :revision => "da563a2339d3fa9c0110ae86cc35fad576f728ab"
  version "2020.29.01"

  depends_on "camlp4" => :build
  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  uses_from_macos "openblas"
  uses_from_macos "readline"
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
