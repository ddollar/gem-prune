require "rubygems"
require "parka/specification"

Parka::Specification.new do |gem|
  gem.name     = "gem-prune"
  gem.version  = GemPrune::VERSION
  gem.summary  = "Identify and remove old gems"
  gem.homepage = "http://github.com/ddollar/gem-prune"
end
