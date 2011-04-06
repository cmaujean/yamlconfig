require 'rubygems'
require 'rake'
$:.unshift 'lib'
require 'yamlconfig'
 
spec = Gem::Specification.new do |s|
  s.name             = "yamlconfig"
  s.version          = YAMLConfig::VERSION
  s.author           = "Christopher Maujean"
  s.email            = "cmaujean@gmail.com"
  s.homepage         = "http://rubyforge.org/projects/ngslib"
  s.rubyforge_project= 'ngslib'
  s.platform         = Gem::Platform::RUBY
  s.summary          = "YAML file based configuration object with an EASY interface"
  s.files            = FileList["{lib,spec}/**/*", "Rakefile", ".gemtest"].to_a
  s.require_path     = "lib"
  s.test_file        = "spec/yamlconfig_spec.rb"
  s.extra_rdoc_files = [ 'lib/LICENSE' ]
  s.has_rdoc         = true
  s.add_development_dependency('rspec')
end

