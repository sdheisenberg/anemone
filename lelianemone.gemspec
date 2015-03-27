
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name = "lelianemone"
  s.version = "0.0.1"
  s.author = "Nick Leli forked from Chris Kite"
  s.homepage = "http://anemone.rubyforge.org"
  s.rubyforge_project = "lelianemone"
  s.platform = Gem::Platform::RUBY
  s.summary = "Anemone web-spider framework"

  # -- these lines are worth some study ---------------------------------------
  # s.files: The files included in the gem. This clever use of git ls-files
  #          ensures that any files tracked in the git repo will be included.
  s.files         = `git ls-files`.split("\n")

  # s.test_files: Files that are used for testing the gem. This line cleverly
  #               supports TestUnit, MiniTest, RSpec, and Cucumber
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  # s.executables: Where any executable files included with the gem live.
  #                These go in bin by convention.
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  # s.require_paths: Directories within the gem that need to be loaded in order
  #                  to load the gem.
  #s.require_paths = ["lib"]
  s.files = Dir['lib/**/*.rb']

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  #s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.require_path = "lib"
  #s.has_rdoc = true
  #s.rdoc_options << '-m' << 'README.rdoc' << '-t' << 'Anemone'
  #s.extra_rdoc_files = ["README.rdoc"]

  s.add_dependency("nokogiri", ">= 1.3.0")
  s.add_dependency("robots", ">= 0.7.2")

  #s.files = `git ls-files`.split("\n")

  #s.test_files = Dir['spec/*.rb']
end
