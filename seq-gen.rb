require 'formula'

class SeqGen < Formula
  homepage 'http://tree.bio.ed.ac.uk/software/seqgen/'
  url 'http://tree.bio.ed.ac.uk/download.php?id=85&num=1', :using => :curl
  sha1 'b96d353c963766d78bde47761bc6cecd6dae0372'
  version '1.3.3'

  def install
    cd 'source' do
      system 'make'
      bin.install 'seq-gen'
    end
  end
end
