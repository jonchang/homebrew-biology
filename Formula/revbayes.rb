class Revbayes < Formula
  # cite Hohna_2016: "https://doi.org/10.1093/sysbio/syw021"
  desc "Bayesian phylogenetic inference with graphical models"
  homepage "https://revbayes.github.io/"
  url "https://github.com/revbayes/revbayes.archive/archive/v1.0.13.tar.gz"
  sha256 "e85e2e1fe182fe9f504900150d936a06d252a362c591b9d3d8272dd085aa85d9"
  head "https://github.com/revbayes/revbayes.git", branch: "development"

  bottle do
    root_url "https://ghcr.io/v2/jonchang/biology"
    rebuild 1
    sha256 cellar: :any,                 catalina:     "6751534e485aa93669a4389e8e514de70b0e98c830cfaaddb4d1f5d8b577cb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "21d6fa3d98adced50d3151568866f568a6ecced897ae2520acd9727845a3db20"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "open-mpi"

  def install
    cd "projects/meson" do
      system "./generate.sh"
    end
    mkdir "build" do
      ENV["BOOST_ROOT"] = Formula["boost"].prefix
      system "meson", "--prefix=#{prefix}", "-Dmpi=true", ".."
      system "ninja", "-v"
      system "ninja", "-v", "install"
    end
  end

  test do
    system "#{bin}/rb", "--version"
  end
end
