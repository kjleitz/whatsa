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
  spec.description   = <<~SPECDESC
    Whatsa harnesses the POWER OF WIKIPEDIA, allowing you to quickly search a
    word or phrase and receive a short (one paragraph) summary about that subject,
    right from the command line! Type 'more' to get a longer summary, 'other' to
    pick a specific category about that subject, and more. If you're too vague,
    Whatsa allows you to select from a disambiguation of topics.
  SPECDESC

  spec.homepage      = "https://github.com/kjleitz/whatsa"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables << "whatsa"
  spec.require_paths = ["lib", "lib/whatsa"]

  spec.add_runtime_dependency "nokogiri", "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
