require 'formula'

class Beast17 < Formula
  homepage 'http://beast.bio.ed.ac.uk/'
  url 'https://beast-mcmc.googlecode.com/files/BEASTv1.7.5.tgz'
  sha1 '825ddd87b67e4f13e078010810b028af78238c44'

  def install
    # Move jars to libexec
    inreplace Dir["bin/*"] do |s|
      s['$BEAST/lib'] = '$BEAST/libexec'
    end

    # Rename binaries
    Dir['bin/*'].each do |f|
      mv f, f + "-1.7"
    end

    mv 'lib', 'libexec'
    prefix.install Dir['*']
  end

  test do
    system "beast -help"
  end

  def caveats; <<-EOS.undent
    Examples are installed in:
      #{opt_prefix}/examples/
  EOS
  end
end
