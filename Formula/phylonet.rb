class Phylonet < Formula
  desc "Reconstructing phylogenetic networks"
  homepage "https://bioinfocs.rice.edu/phylonet"
  url "https://bioinfocs.rice.edu/sites/g/files/bxs266/f/kcfinder/files/PhyloNet_3.6.4.jar", using: :nounzip
  sha256 "3919c3408fb5f7af0d465738475cc20d2952eba37e09c51ee3f3ba8df966a8d4"
  revision 1

  depends_on "openjdk"

  def install
    libexec.install Dir["*.jar"]
    bin.write_jar_script Dir[libexec/"*.jar"][0], "phylonet"
  end

  test do
    system "#{bin}/phylonet"
  end
end
