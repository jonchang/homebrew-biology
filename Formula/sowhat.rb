class RRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { which("R") }

  def message; <<~EOS
    R is required; install it via one of:
      brew install r
      brew cask install r-app
    EOS
  end
end

class Sowhat < Formula
  # cite Church_2015: "https://doi.org/10.1093/sysbio/syv055"
  desc "Phylogenetic parametric bootstrapping with the SOWH test"
  homepage "https://github.com/josephryan/sowhat"
  url "https://github.com/josephryan/sowhat/archive/v0.36.tar.gz"
  sha256 "f1e762e6138f395db690f0832f158cddecafd050d0c1965bd51a85b9bbaaf54e"

  depends_on "cpanminus" => :build
  depends_on "perl" unless OS.mac?
  depends_on "brewsci/bio/raxml"
  depends_on "brewsci/bio/seq-gen"
  depends_on RRequirement

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    perl = OS.mac? ? "/usr/bin/perl" : HOMEBREW_PREFIX/"bin/perl"
    inreplace "sowhat", "'raxmlHPC'", "'raxmlHPC-SSE3'" # Homebrew default

    system "cpanm", "--self-contained", "-l", libexec, "Statistics::R", "JSON"
    system perl, "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "test"
    system "make", "install"
    (bin/"sowhat").write_env_script("#{libexec}/bin/sowhat", :PERL5LIB => ENV["PERL5LIB"])
    pkgshare.install "examples"
    pkgshare.install "published_datasets"
  end

  test do
    system "#{bin}/sowhat", "--constraint=#{pkgshare}/examples/H0.tre", "--aln=#{pkgshare}/examples/nt.phy", "--dir=t", "--name=t"
  end
end
