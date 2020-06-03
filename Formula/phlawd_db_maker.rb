class PhlawdDbMaker < Formula
  # cite Smith_2009: "https://doi.org/10.1186/1471-2148-9-37"
  desc "Creates databases for phlawd and pyPHLAWD"
  homepage "https://github.com/blackrim/phlawd_db_maker"
  url "https://github.com/blackrim/phlawd_db_maker.git",
    :revision => "72c10e995e7225b6eeb8b0f22cc9dc70017ae43b"
  version "2020.03.06"
  head "https://github.com/blackrim/phlawd_db_maker.git"

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
