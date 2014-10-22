require "formula"

# This is a non-functional example formula to showcase all features and
# therefore, it's overly complex and dupes stuff just to comment on it.
# You may want to use `brew create` to start your own new formula!
# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook

## Naming -- Every Homebrew formula is a class of the type `Formula`.
# Ruby classes have to start Upper case and dashes are not allowed.
# So we transform: `example-formula.rb` into `ExampleFormula`. Further,
# Homebrew does enforce that the name of the file and the class correspond.
# Check with `brew search` that the name is free.
class ExampleFormula < Formula
  homepage "http://www.example.com" # used by `brew home example-formula`.

  # The url of the archive. Prefer https (security and proxy issues):
  url "https://packed.sources.and.we.prefer.https.example.com/archive-1.2.3.tar.bz2"
  mirror "https://in.case.the.host.is.down.example.com" # `mirror` is optional.

  # Optionally specify the download strategy `:using => ...`
  #     `:git`, `:hg`, `:svn`, `:bzr`, `:cvs`,
  #     `:curl` (normal file download. Will also extract.)
  #     `:nounzip` (without extracting)
  #     `:post` (download via an HTTP POST)
  #     `S3DownloadStrategy` (download from S3 using signed request)
  url "https://some.dont.provide.archives.example.com", :using => :git, :tag => "1.2.3"

  # version is seldom needed, because it's usually autodetected from the URL/tag.
  version "1.2-final"

  # For integrity and security, we verify the hash (`openssl dgst -sha1 <FILE>`)
  # You may also use sha256 if the software uses sha256 on their homepage.
  # Leave it empty at first and `brew install` will tell you the expected.
  sha1 "cafebabe78901234567890123456789012345678"

  # Stable-only dependencies should be nested inside a `stable` block rather than
  # using a conditional. It is preferrable to also pull the URL and checksum into
  # the block if one is necessary.
  stable do
    url "https://example.com/foo-1.0.tar.gz"
    sha1 "cafebabe78901234567890123456789012345678"

    depends_on "libxml2"
    depends_on "libffi"
  end

  # Optionally, specify a repository to be used. Brew then generates a
  # `--HEAD` option. Remember to also test it.
  # The download strategies (:using =>) are the same as for `url`.
  head "https://we.prefer.https.over.git.example.com/.git"
  head "https://example.com/.git", :branch => "name_of_branch", :revision => "abc123"
  head "https://hg.is.awesome.but.git.has.won.example.com/", :using => :hg # If autodetect fails.

  head do
    url "https://example.com/repo.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # The optional devel block is only executed if the user passes `--devel`.
  # Use this to specify a not-yet-released version of a software.
  devel do
    url "https://example.com/archive-2.0-beta.tar.gz"
    sha1 "1234567890123456789012345678901234567890"

    depends_on "cairo"
    depends_on "pixman"
  end


  ## Options

  # Options can be used as arguments to `brew install`.
  # To switch features on/off: `"with-something"` or `"with-otherthing"`.
  # To use another software: `"with-other-software"` or `"without-foo"`
  # Note, that for dependencies that are `:optional` or `:recommended`, options
  # are generated automatically.
  # Build a universal (On newer intel Macs this means a combined 32bit and
  # 64bit binary/library). TODO: better explain what this means for PPC.
  option :universal
  option "with-spam", "The description goes here without a dot at the end"
  option "with-qt", "Text here overwrites the autogenerated one from `depends_on "qt"`"

  ## Bottles

  # Bottles are pre-built and added by the Homebrew maintainers for you.
  # If you maintain your own repository, you can add your own bottle links.
  # Read in the wiki about how to provide bottles:
  # <https://github.com/Homebrew/homebrew/wiki/Bottles>
  bottle do
    root_url "http://mikemcquaid.com" # Optional root to calculate bottle URLs
    prefix "/opt/homebrew" # Optional HOMEBREW_PREFIX in which the bottles were built.
    cellar "/opt/homebrew/Cellar" # Optional HOMEBREW_CELLAR in which the bottles were built.
    revision 1 # Making the old bottle outdated without bumping the version of the formula.
    sha1 "d3d13fe6f42416765207503a946db01378131d7b" => :mountain_lion
    sha1 "cdc48e79de2dee796bb4ba1ad987f6b35ce1c1ee" => :lion
    sha1 "a19b544c8c645d7daad1d39a070a0eb86dfe9b9c" => :snow_leopard
    sha1 "583dc9d98604c56983e17d66cfca2076fc56312b" => :snow_leopard_32
  end

  def pour_bottle?
    # Only needed if this formula has to check if using the pre-built
    # bottle is fine.
    true
  end

  ## keg_only

  # Software that will not be sym-linked into the `brew --prefix` will only
  # live in it's Cellar. Other formulae can depend on it and then brew will
  # add the necessary includes and libs (etc.) during the brewing of that
  # other formula. But generally, keg_only formulae are not in your PATH
  # and not seen by compilers if you build your own software outside of
  # Homebrew. This way, we don't shadow software provided by OS X.
  keg_only :provided_by_osx
  keg_only "because I want it so"


  ## Dependencies

  # The dependencies for this formula. Use strings for the names of other
  # formulae. Homebrew provides some :special dependencies for stuff that
  # requires certain extra handling (often changing some ENV vars or
  # deciding if to use the system provided version or not.)

  # `:build` means this dep is only needed during build.
  depends_on "cmake" => :build
  # Explictly name formulae in other taps. Non-optional tap dependencies won't
  # be accepted in core.
  depends_on "homebrew/dupes/tcl-tk"
  # `:recommended` dependencies are built by default. But a `--without-...`
  # option is generated to opt-out.
  depends_on "readline" => :recommended
  # `:optional` dependencies are NOT built by default but a `--with-...`
  # options is generated.
  depends_on "glib" => :optional
  # If you need to specify that another formula has to be built with/out
  # certain options (note, no `--` needed before the option):
  depends_on "zeromq" => "with-pgm"
  depends_on "qt" => ["with-qtdbus", "developer"] # Multiple options.
  # Optional and enforce that boost is built with `--with-c++11`.
  depends_on "boost" => [:optional, "with-c++11"]
  # If a dependency is only needed in certain cases:
  depends_on "sqlite" if MacOS.version == :leopard
  depends_on :xcode # If the formula really needs full Xcode.
  depends_on :tex # Homebrew does not provide a Tex Distribution.
  depends_on :fortran # Checks that `gfortran` is available or `FC` is set.
  depends_on :mpi => :cc # Needs MPI with `cc`
  depends_on :mpi => [:cc, :cxx, :optional] # Is optional. MPI with `cc` and `cxx`.
  depends_on :macos => :lion # Needs at least Mac OS X "Lion" aka. 10.7.
  depends_on :arch => :intel # If this formula only builds on intel architecture.
  depends_on :arch => :x86_64 # If this formula only build on intel x86 64bit.
  depends_on :arch => :ppc # Only builds on PowerPC?
  depends_on :ld64 # Sometimes ld fails on `MacOS.version < :leopard`. Then use this.
  depends_on :x11 # X11/XQuartz components.
  depends_on :mysql => :recommended
  # It is possible to only depend on something if
  # `build.with?` or `build.without? "another_formula"`:
  depends_on :mysql # allows brewed or external mysql to be used
  depends_on :postgresql if build.without? "sqlite"
  depends_on :hg # Mercurial (external or brewed) is needed

  # If any Python >= 2.7 < 3.x is okay (either from OS X or brewed):
  depends_on :python
  # Python 3.x if the `--with-python3` is given to `brew install example`
  depends_on :python3 => :optional

  # Modules/Packages from other languages, such as :chicken, :jruby, :lua,
  # :node, :ocaml, :perl, :python, :rbx, :ruby, can be specified by
  depends_on "some_module" => :lua

  ## Conflicts

  # If this formula conflicts with another one:
  conflicts_with "imagemagick", :because => "because this is just a stupid example"


  ## Failing with a certain compiler?

  # If it is failing for certain compiler:
  fails_with :llvm do # :llvm is really llvm-gcc
    build 2334
    cause "Segmentation fault during linking."
  end

  fails_with :clang do
    build 425
    cause "multiple configure and compile errors"
  end

  ## Resources

  # Additional downloads can be defined as resources and accessed in the
  # install method. Resources can also be defined inside a stable, devel, or
  # head block. This mechanism replaces ad-hoc "subformula" classes.
  resource "additional_files" do
    url "https://example.com/additional-stuff.tar.gz"
    sha1 "deadbeef7890123456789012345678901234567890"
  end


  ## Patches

  # External patches can be declared using resource-style blocks.
  patch do
    url "https://example.com/example_patch.diff"
    sha1 "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
  end

  # A strip level of -p1 is assumed. It can be overridden using a symbol
  # argument:
  patch :p0 do
    url "https://example.com/example_patch.diff"
    sha1 "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
  end

  # Patches can be declared in stable, devel, and head blocks. This form is
  # preferred over using conditionals.
  stable do
    patch do
      url "https://example.com/example_patch.diff"
      sha1 "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    end
  end

  # Embedded (__END__) patches are declared like so:
  patch :DATA
  patch :p0, :DATA

  # Patches can also be embedded by passing a string. This makes it possible
  # to provide multiple embedded patches while making only some of them
  # conditional.
  patch :p0, "..."

  ## The install method.

  def install
    # Now the sources (from `url`) are downloaded, hash-checked and
    # Homebrew has changed into a temporary directory where the
    # archive has been unpacked or the repository has been cloned.

    # Print a warning (do this rarely)
    opoo "Dtrace features are experimental!" if build.with? "dtrace"

    # Sometimes we have to change a bit before we install. Mostly we
    # prefer a patch but if you need the `prefix` of this formula in the
    # patch you have to resort to `inreplace`, because in the patch
    # you don't have access to any var defined by the formula. Only
    # HOMEBREW_PREFIX is available in the embedded patch.
    # inreplace supports regular expressions.
    inreplace "somefile.cfg", /look[for]what?/, "replace by #{bin}/tool"

    # To call out to the system, we use the `system` method and we prefer
    # you give the args separately as in the line below, otherwise a subshell
    # has to be opened first.
    system "./bootstrap.sh", "--arg1", "--prefix=#{prefix}"

    # For Cmake, we have some necessary defaults in `std_cmake_args`:
    system "cmake", ".",  *std_cmake_args

    # If the arguments given to configure (or make or cmake) are depending
    # on options defined above, we usually make a list first and then
    # use the `args << if <condition>` to append to:
    args = ["--option1", "--option2"]
    args << "--i-want-spam" if build.with? "spam"
    args << "--qt-gui" if build.with? "qt" # "--with-qt" ==> build.with? "qt"
    args << "--some-new-stuff" if build.head? # if head is used instead of url.
    args << "--universal-binary" if build.universal?

    # The `build.with?` and `build.without?` are smart enough to do the
    # right thing with respect to defaults defined via `:optional` and
    # `:recommended` dependencies.

    # If you need to give the path to lib/include of another brewed formula
    # please use the `opt_prefix` instead of the `prefix` of that other
    # formula. The reasoning behind this is that `prefix` has the exact
    # version number and if you update that other formula, things might
    # break if they remember that exact path. In contrast to that, the
    # `$(brew --prefix)/opt/formula` is the same path for all future
    # versions of the formula!
    args << "--with-readline=#{Formula["readline"].opt_prefix}/lib" if build.with? "readline"

    # Most software still uses `configure` and `make`.
    # Check with `./configure --help` what our options are.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args # our custom arg list (needs `*` to unpack)

    # If your formula's build system is not thread safe:
    ENV.deparallelize

    # A general note: The commands here are executed line by line, so if
    # you change some variable or call a method like ENV.deparallelize, it
    # only affects the lines after that command.

    # Do something only for clang
    if ENV.compiler == :clang
      # modify CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS in one go:
      ENV.append_to_cflags "-I ./missing/includes"
    end

    # Overwriting any env var:
    ENV["LDFLAGS"] = "--tag CC"

    system "make", "install"

    # We are in a temporary directory and don't have to care about cleanup.

    # Instead of `system "cp"` or something, call `install` on the Pathname
    # objects as they are smarter with respect to correcting access rights.
    # (`install` is a Homebrew mixin into Ruby's Pathname)

    # The pathnames defined in the formula
    prefix # == HOMEBREW_PREFIX+"Cellar"+name+version
    bin # == prefix+"bin"
    doc # == share+"doc"+name
    include # == prefix+"include"
    info # == share+"info"
    lib # == prefix+"lib"
    libexec # == prefix+"libexec"
    buildpath # The temporary directory where build occurs.

    man # share+"man"
    man1 # man+"man1"
    man2 # man+"man2"
    man3 # man+"man3"
    man4 # man+"man4"
    man5 # man+"man5"
    man6 # man+"man6"
    man7 # man+"man7"
    man8 # man+"man8"
    sbin # prefix+"sbin"
    share # prefix+"share"
    frameworks # prefix+"Frameworks"
    kext_prefix # prefix+"Library/Extensions"
    # Configuration stuff that will survive formula updates
    etc # HOMEBREW_PREFIX+"etc"
    # Generally we don't want var stuff inside the keg
    var # HOMEBREW_PREFIX+"var"
    bash_completion # prefix+"etc/bash_completion.d"
    zsh_completion # share+"zsh/site-functions"
    # Further possibilities with the pathnames:
    # http://www.ruby-doc.org/stdlib-1.8.7/libdoc/pathname/rdoc/Pathname.html

    # Copy `./example_code/simple/ones` to share/demos
    (share/"demos").install "example_code/simple/ones"
    # Copy `./example_code/simple/ones` to share/demos/examples
    (share/"demos").install "example_code/simple/ones" => "examples"

    # Additional downloads can be defined as resources (see above).
    # The stage method will create a temporary directory and yield
    # to a block.
    resource("additional_files").stage { bin.install "my/extra/tool" }

    # `name` and `version` are accessible too, if you need them.
  end


  ## Caveats

  def caveats
    "Are optional. Something the user should know?"
  end

  def caveats
    s = <<-EOS.undent
      Print some important notice to the user when `brew info <formula>` is
      called or when brewing a formula.
      This is optional. You can use all the vars like #{version} here.
    EOS
    s += "Some issue only on older systems" if MacOS.version < :mountain_lion
    s
  end


  ## Test (is optional but makes us happy)

  test do
    # `test do` will create, run in, and delete a temporary directory.

    # We are fine if the executable does not error out, so we know linking
    # and building the software was ok.
    system bin/"foobar", "--version"

    (testpath/"Test.file").write <<-EOS.undent
      writing some test file, if you need to
    EOS
    # To capture the output of a command, we use backtics:
    assert_equal "OK", ` test.file`.strip

    # Need complete control over stdin, stdout?
    require "open3"
    Open3.popen3("#{bin}/example", "argument") do |stdin, stdout, _|
      stdin.write("some text")
      stdin.close
      assert_equal "result", stdout.read
    end

    # The test will fail if it returns false, or if an exception is raised.
    # Failed assertions and failed `system` commands will raise exceptions.
  end


  ## Plist handling

  # Define this method to provide a plist.
  # Todo: Expand this example with a little demo plist? I dunno.
  # There is more to startup plists. Help, I suck a plists!
  def plist; nil; end
end

__END__
# Room for a patch after the `__END__`
# Read in the wiki about how to get a patch in here:
#    https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# In short, `brew install --interactive --git <formula>` and make your edits.
# Then `git diff >> path/to/your/formula.rb`
# Note, that HOMEBREW_PREFIX will be replaced in the path before it is
# applied. A patch can consit of several hunks.
