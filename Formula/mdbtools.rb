class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v1.0.1/mdbtools-1.0.1.tar.gz"
  sha256 "ff9c425a88bc20bf9318a332eec50b17e77896eef65a0e69415ccb4e396d1812"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/hongyuanjia/homebrew-mdbtools/releases/download/mdbtools-1.0.1"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "8fdffad4ae1dbae8803e5fca4633307ad73c504abe8d80ed1c2b77c103c7e9a7"
    sha256 cellar: :any,                 ventura:       "3145493958ef8e2e5c65b32317f0dc754985adae6199e8762cee14f728e7204f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1cf1d066dae1f7c6f617e8bcc05c1a1571e257356b313050b4e1fd3a5f95d33"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "gawk" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "flex"
  depends_on "glib"
  depends_on "readline"
  depends_on "unixodbc"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.deparallelize

    odbc_args = %W[
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
    ]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-man", *std_configure_args, *odbc_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mdb-schema --drop-table test 2>&1", 1)

    expected_output = <<~EOS
      File not found
      Could not open file
    EOS
    assert_match expected_output, output
  end
end
