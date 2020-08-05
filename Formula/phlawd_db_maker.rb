class PhlawdDbMaker < Formula
  # cite Smith_2009: "https://doi.org/10.1186/1471-2148-9-37"
  desc "Creates databases for phlawd and pyPHLAWD"
  homepage "https://github.com/blackrim/phlawd_db_maker"
  url "https://github.com/blackrim/phlawd_db_maker.git",
    revision: "72c10e995e7225b6eeb8b0f22cc9dc70017ae43b"
  version "2020.03.06"
  head "https://github.com/blackrim/phlawd_db_maker.git"

  bottle do
    root_url "https://dl.bintray.com/jonchang/bottles-biology"
    cellar :any_skip_relocation
    sha256 "a70990f994f33d665ad74556a1424c1eb8e91a5aa1298af826769d13523d307e" => :catalina
    sha256 "c05cdecc545234e956e062702a51065fa82f4ed13b32ef89b0d3542b3384a8d3" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "wget"

  uses_from_macos "sqlite"

  def install
    cd "deps/sqlitewrapped-1.3.1" do
      system "make", "clean"
      system "make"
      cp "libsqlitewrapped.a", OS.mac? ? "../mac" : "../linux"
    end
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "phlawd_db_maker"
  end

  test do
    system "#{bin}/phlawd_db_maker"
  end
end
