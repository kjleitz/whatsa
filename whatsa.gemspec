# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whatsa/version'

Gem::Specification.new do |spec|
  spec.name          = "whatsa"
  spec.version       = Whatsa::VERSION
  spec.authors       = ["Keegan Leitz"]
  spec.email         = ["kjleitz@gmail.com"]

  spec.summary       = %q{What is that? Okay, okay, I don't need a lecture... just gimme the short 'n sweet!}
  spec.description   = %q{Whatsa is a CLI app that allows you to search a term or phrase and receive a quick summary about that subject. It searches your term on Wikipedia and finds the page you're most likely looking for. Whatsa then gives you the first paragraph of that article, then lists the sections on the page ("History", "Early Life", "Uses", etc.). You can select one of those sections, if you'd like, and it will give you the first paragraph of that section, too. If that's not enough for you, you can ask for more, and it will show you the full section.}
  spec.homepage      = "https://github.com/kjleitz/whatsa"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  # spec.add_development_dependency "open-uri"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "pry"

end
