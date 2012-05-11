require 'formula'

class Velvet < Formula
  version '1.2.05'
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  # doesn't seem to have stable tarballs
  url 'https://github.com/dzerbino/velvet.git', :revision => 'aeb11f8058e4ea794a6ec425c168ffcbbfd1bbbc'
  head 'https://github.com/dzerbino/velvet.git'

  def install
    inreplace 'Makefile' do |s|
      # recommended in Makefile for compiling on Mac OS X
      s.change_make_var! "CFLAGS", "-Wall -m64"
    end
    system "make MAXKMERLENGTH=96"
    bin.install 'velveth', 'velvetg'
  end

  def test
    quiet_system "#{bin}/velveth"
  end
end
