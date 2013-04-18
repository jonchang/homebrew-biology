require 'formula'

class Bucky < Formula
  homepage 'http://www.stat.wisc.edu/~ane/bucky/'
  url 'http://www.stat.wisc.edu/~ane/bucky/v1.4/bucky-1.4.2.tgz'
  sha1 'c2c8eabfa63aee38f8f0933ccdc77b06377217db'


  def install
    cd 'src' do
      system "make"
      bin.install "mbsum", "bucky"
    end
    (share/'bucky').install ["data", "scripts", "doc"]
  end

  def caveats
    <<-EOS.undent
      The manual, examples, and scripts are installed to:
          #{share}/bucky
    EOS
  end

  test do
    system "bucky --version"
  end
end
