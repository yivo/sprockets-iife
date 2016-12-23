# encoding: utf-8
# frozen_string_literal: true

require 'sprockets-iife'
require 'test/unit'
require 'fileutils'

class SprocketsIIFETest < Test::Unit::TestCase
  def test_registration
    app = create_rails_application
    app.initialize!

    assert app.assets.bundle_processors.key?('application/javascript')
    assert Array === app.assets.bundle_processors['application/javascript']
    assert app.assets.bundle_processors['application/javascript'].include?(SprocketsIIFE::BundleProcessor)

    assert app.assets.postprocessors.key?('application/javascript')
    assert Array === app.assets.postprocessors['application/javascript']
    assert app.assets.postprocessors['application/javascript'].include?(SprocketsIIFE::ItemProcessor)
  end

  def test_compilation
    app = create_rails_application
    app.initialize!
    task = create_sprockets_task(app)
    task.instance_exec { manifest.compile(assets) }

    expected = <<-JAVASCRIPT.squish
      (function(/* jsbundle-iife */) {
        jsbundle.js();
        foo.js();
        (function(/* bar-iife */) {
          bar.js();
        }).call(this); 
      }).call(this);
    JAVASCRIPT
    assert_equal expected, app.assets['jsbundle.js'].to_s.squish

    expected = <<-JAVASCRIPT.squish
      (function(/* coffeebundle-iife */) {
        (function() { coffeebundle.coffee(); }).call(this);
        (function() { foo.coffee(); }).call(this);
        (function(/* bar-iife */) {
          (function() { bar.coffee(); }).call(this);
        }).call(this);
      }).call(this);
    JAVASCRIPT
    assert_equal expected, app.assets['coffeebundle.js'].to_s.squish

    expected = <<-JAVASCRIPT.squish
      (function(/* mixedbundle-iife */) {
        (function() { mixedbundle.coffee(); }).call(this);

        foo.js();

        (function(/* bar-iife */) {
          (function() { 
            bar.coffee(); 
          }).call(this);

          (function(/* baz-iife */) { 
            baz.js(); 
          }).call(this);
        }).call(this);

      }).call(this);
    JAVASCRIPT
    assert_equal expected, app.assets['mixedbundle.js'].to_s.squish
  end

  def setup
    super
    clear_tmp
    clear_logs
  end

  def teardown
    super
    clear_tmp
    if defined?(Rails) && Rails.respond_to?(:application=)
      Rails.application = nil
    end
  end

private
  def create_rails_application
    require 'rails'
    require 'sprockets/railtie'
    require 'sprockets-iife/railtie'

    Class.new(Rails::Application) do
      config.eager_load = false
      config.assets.enabled = true
      config.assets.gzip = false
      config.assets.paths = [Rails.root.join('test/fixtures/javascripts').to_s]
      config.assets.precompile = %w( jsbundle.js coffeebundle.js mixedbundle.js )
      config.paths['public'] = [Rails.root.join('tmp').to_s]
      config.active_support.deprecation = :stderr
    end
  end

  def create_sprockets_task(app)
    require 'sprockets/version' # Fix for sprockets 2.x

    if Sprockets::VERSION.start_with?('2')
      require 'rake/sprocketstask'
      Rake::SprocketsTask.new do |t|
        t.environment = app.assets
        t.output      = "#{app.config.paths['public'][0]}#{app.config.assets.prefix}"
        t.assets      = app.config.assets.precompile
      end
    else
      require 'sprockets/rails/task'
      Sprockets::Rails::Task.new(app)
    end
  end

  def clear_tmp
    FileUtils.rm_rf(File.expand_path('../../tmp', __FILE__))
  end

  def clear_logs
    FileUtils.rm_rf(File.expand_path('../../log', __FILE__))
  end
end
