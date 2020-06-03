class Shoremap < Formula
  # cite Sun_2015: "https://doi.org/10.1007/978-1-4939-2444-8_19"
  desc "Fast, accurate identification of causal mutations in plants"
  homepage "http://bioinfo.mpipz.mpg.de/shoremap/index.html"
  url "http://bioinfo.mpipz.mpg.de/shoremap/SHOREmap_v3.6.tar.gz"
  sha256 "0da4179e92cbc68434a9d8eff7bd5fff55c89fd9a543a2db6bd0f69074f2ec70"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any
    sha256 "b20d8d0905e05b45c12d29d91cb3e72be080b8ae7a69b5c369f48318c9620e71" => :catalina
    sha256 "9afb5753a0fa928613c78c423e9387ec9d012cd6fc8339471b2aaf0d596d5ad0" => :x86_64_linux
  end

  depends_on "openmotif"

  if OS.mac?
    depends_on :x11
  else
    depends_on "patchelf" => :build
    depends_on "linuxbrew/xorg/libxt"
    depends_on "mesa"
  end

  resource "dislin" do
    if OS.mac?
      url "ftp://ftp.gwdg.de/pub/grafik/dislin/darwin/dislin-11.3.darwin.intel.64.tar.gz"
      sha256 "23ccc0be6443c7fdb176630f942b650b1b6180edb5b4dfa55458c9fce5b002b8"
    else
      url "ftp://ftp.gwdg.de/pub/grafik/dislin/linux/i586_64/dislin-11.3.linux.i586_64.tar.gz"
      sha256 "1874980c7b0526c5b2df5863805e3d381eece2f1df038c6389ea60bb8aacb093"
    end
  end

  def install
    resource("dislin").stage do
      ENV["DISLIN"] = libexec/"dislin"
      (libexec/"dislin").install Dir["examples/*.h"]
      system "./INSTALL"
    end

    # Clean up libs we don't need that cause problems
    # with `brew linkage --test`
    %w[bin dislin.dl perl python python3 ruby tcl java].each do |f|
      rm_rf "#{libexec}/dislin/#{f}"
    end

    # Bash makefile into shape
    inreplace "makefile" do |s|
      s.gsub! /-L[^ ]+/, ""
      s.gsub! /^(\tg\+\+.*)/, "\\1 -lXm -L#{libexec}/dislin -I#{libexec}"
    end

    rm_rf "dislin"
    system "make"
    bin.install "SHOREmap"
    pkgshare.install "examples"
    prefix.install Dir["COPYING*"]

    # Patch rpaths etc
    if OS.mac?
      MachO::Tools.change_install_name bin/"SHOREmap",
        "/usr/local/lib/libdislin_d.11.dylib",
        "#{libexec}/dislin/libdislin_d.11.dylib"

      Dir["#{libexec}/dislin/lib/*.dylib"].each do |f|
        MachO::Tools.change_install_name f,
          "/usr/X11/lib/libGL.1.dylib",
          "#{MacOS::X11.lib}/libGL.1.dylib"
      end
    else
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", "#{HOMEBREW_PREFIX}/lib:#{libexec}/dislin",
        bin/"SHOREmap"

      Dir["#{libexec}/dislin/lib/*.so"].each do |f|
        system "patchelf", "--set-rpath", HOMEBREW_PREFIX/"lib", f
      end
    end
  end

  def caveats
    <<~EOS
      SHOREmap requires the DISLIN library, which is free to use for
      non-commercial purposes. The full license text can be read at:
        https://www.mps.mpg.de/dislin/eula

      We have agreed to this license on your behalf. If this is
      unacceptable, you should uninstall SHOREmap.
    EOS
  end

  test do
    system "SHOREmap", "about"
  end
end
