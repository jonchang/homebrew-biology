class PhlawdDbMaker < Formula
  # cite Smith_2009: "https://doi.org/10.1186/1471-2148-9-37"
  desc "Creates databases for phlawd and pyPHLAWD"
  homepage "https://github.com/blackrim/phlawd_db_maker"
  url "https://github.com/blackrim/phlawd_db_maker.git",
    revision: "e9b0a9d6e74d34efa202674ca465899b1466e1bf"
  version "2021.01.25"
  head "https://github.com/blackrim/phlawd_db_maker.git"

  bottle do
    root_url "https://ghcr.io/v2/jonchang/biology"
    sha256 cellar: :any_skip_relocation, catalina:     "34038c746a4356ed9d016c2382ddf321acc9fb6e74bbe65fb50ed084b26541fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f2a93cf8dc26c5ce33ca0a11198cda95bfc8b650ee98e7e93b7d6b9dbb2017fa"
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
