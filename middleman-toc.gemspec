# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'middleman_toc/version'

Gem::Specification.new do |s|
  s.name         = "middleman-toc"
  s.version      = MiddlemanToc::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "me@svenfuchs.com"
  s.homepage     = "https://github.com/svenfuchs/middleman-toc"
  s.summary      = "Middleman Table of Contents"
  s.files        = Dir['{lib/**/*,spec/**/*,[A-Z]*}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'titleize'
end
