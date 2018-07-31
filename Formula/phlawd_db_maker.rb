class PhlawdDbMaker < Formula
  desc "Creates databases for phlawd and pyPHLAWD"
  homepage "https://github.com/blackrim/phlawd_db_maker"
  url "https://github.com/blackrim/phlawd_db_maker.git", :revision => "dfbf52af3ab355074dd504a1ca22318b2d72a689"
  version "2018.04.11"
  head "https://github.com/blackrim/phlawd_db_maker.git"

  depends_on "cmake" => :build
  depends_on "sqlite" unless OS.mac?
  depends_on "wget"

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
