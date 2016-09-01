class Roguenarok < Formula
  desc "Identify rogue taxa in a tree set"
  homepage "http://sco.h-its.org/exelixis/web/software/roguenarok/roguenarok.html"
  url "https://github.com/aberer/RogueNaRok/archive/v1.0.tar.gz"
  sha256 "91371822f0523f8331647448ae21a9688801c1b4182fd3d40a0555336404ed72"
  head "https://github.com/aberer/RogueNaRok.git"
  # doi "10.1093/sysbio/sys078"
  # tag "bioinformatics"

  def install
    system "make", "mode=parallel"
    bin.install %W[RogueNaRok-parallel rnr-lsi rnr-mast rnr-prune rnr-tii]
    if build.head?
      pkgshare.install(["example", "utils"])
    end
  end

  def caveats
    if build.head?
      <<-EOS.undent
        The examples and utilities are installed to
        #{pkgshare}
      EOS
    end
  end

  test do
    cp Dir[pkgshare/"example/*"], testpath
    system "#{bin}/RogueNaRok-parallel", "-i", "150.bs", "-t", "150.tre", "-n", "id", "-T", "2"
    assert File.exist? "RogueNaRok_droppedRogues.id"
  end
end
