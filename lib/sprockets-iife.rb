# encoding: utf-8
# frozen_string_literal: true

require 'sprockets'

Sprockets::VERSION =~ /\A\d/
if $&.to_i > 2
  require 'sprockets-iife/processor'
else
  require 'sprockets-iife/legacy-processor'
end

require 'sprockets-iife/railtie' if defined?(Rails)
