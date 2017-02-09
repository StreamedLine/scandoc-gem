# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scandoc/version'

Gem::Specification.new do |spec|
  spec.name          = "scandoc"
  spec.version       = Scandoc::VERSION
  spec.authors       = ["David Lewitan"]
  spec.email         = ["dovidlwtn@gmail.com"]

  spec.summary       = "allows display of rubydoc (core) in terminal"
  spec.description   = "search for a keyword. select desired result. display in terminal or open in browser"
  spec.homepage      = "https://github.com/StreamedLine/scandoc-gem.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://mygemserver.com"
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
  spec.add_dependency "nokogiri", "~>1.7.0.1"
  spec.add_dependency "clipboard"
  spec.add_dependency "launchy"
  spec.add_dependency "colorize" 
end
