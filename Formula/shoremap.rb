class Shoremap < Formula
  # cite Sun_2015: "https://doi.org/10.1007/978-1-4939-2444-8_19"
  desc "Fast, accurate identification of causal mutations in plants"
  homepage "http://bioinfo.mpipz.mpg.de/shoremap/index.html"
  url "http://bioinfo.mpipz.mpg.de/shoremap/SHOREmap_v3.8.tar.gz"
  sha256 "5d6841b3e8c33d11179420cb35d520a9741948810af234ac3b43a00fd2ffe6a2"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any
    sha256 "b20d8d0905e05b45c12d29d91cb3e72be080b8ae7a69b5c369f48318c9620e71" => :catalina
    sha256 "9afb5753a0fa928613c78c423e9387ec9d012cd6fc8339471b2aaf0d596d5ad0" => :x86_64_linux
  end

  depends_on "libxt"
  depends_on "mesa"
  depends_on "openmotif"

  resource "dislin" do
    on_macos do
      url "ftp://ftp.gwdg.de/pub/grafik/dislin/darwin/dislin-11.3.darwin.intel.64.tar.gz"
      sha256 "87c2ae93541ed653f1a9542738af291e2aa1083fabe514203151780282b623d6"
    end

    on_linux do
      url "ftp://ftp.gwdg.de/pub/grafik/dislin/linux/i586_64/dislin-11.3.linux.i586_64.tar.gz"
      sha256 "1be4bdcfd045776010a18d346d4918ae6363feb8a73b7ae8df6ff190a2e3ca77"
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
          Formula["mesa"].lib/"libGL.1.dylib"
      end
    end

    if OS.linux?
      (bin/"SHOREmap").patch!(interpreter: (HOMEBREW_PREFIX/"lib/ld.so").to_s,
                              rpath:       "#{HOMEBREW_PREFIX}/lib:#{libexec}/dislin")

      Dir["#{libexec}/dislin/lib/*.so"].each do |f|
        Pathname(f).patch!(rpath: (HOMEBREW_PREFIX/"lib").to_s)
      end
    end
  end

  def caveats
    <<~EOS
      We have agreed to the DISLIN license on your behalf:
        https://www.mps.mpg.de/dislin/eula
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    system "SHOREmap", "about"
  end
end
