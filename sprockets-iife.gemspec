# encoding: utf-8
# frozen_string_literal: true

require File.expand_path('../lib/sprockets-iife/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = 'sprockets-iife'
  s.version         = SprocketsIIFE::VERSION
  s.author          = 'Yaroslav Konoplov'
  s.email           = 'eahome00@gmail.com'
  s.summary         = 'IIFE wrapper generator for Sprockets'
  s.description     = 'Generates IIFE wrapper for Sprockets JavaScript files'
  s.homepage        = 'https://github.com/yivo/sprockets-iife'
  s.license         = 'MIT'

  s.executables     = `git ls-files -z -- bin/*`.split("\x0").map{ |f| File.basename(f) }
  s.files           = `git ls-files -z`.split("\x0")
  s.test_files      = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths   = ['lib']

  s.add_dependency 'sprockets', '>= 2.0', '< 5.0'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'appraisal', '~> 2.1'
  s.add_development_dependency 'test-unit', '~> 3.1'
  s.add_development_dependency 'coffee-rails'
end
