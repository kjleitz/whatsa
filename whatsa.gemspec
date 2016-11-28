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
  spec.description   = %q{== Whatsa is a CLI app that allows you to search a word or phrase and receive a quick summary about that subject. It searches your query on Wikipedia and finds the page you're most likely looking for. If you've been somewhat vague, or your search term could refer to multiple things, it will ask you to select from a disambiguation of topics. Usually, however, your term will go straight to an article. Whatsa then gives you the first paragraph of that article (usually a surprisingly decent summary).

If you're not super satisfied with that bit of information (and you need to know a little more) you can type `more` to get a better picture of that subject. If you're _still_ not satisfied, and you want to know something _specific_ about the thing you've searched, type `other`, and it will list the categories of information Wikipedia knows about the subject (its "History", "Early Life", "Uses", etc.). You can select one of those sections, if you'd like, and it will give you the first paragraph of that section, too (which you can extend similarly with another `more` command). You can make a new query with `new`, ask for help at any time with `help`, or exit the application with `exit`.}
  spec.homepage      = "https://github.com/kjleitz/whatsa"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
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
  spec.add_development_dependency "nokogiri"
  # spec.add_development_dependency "pry"

end
