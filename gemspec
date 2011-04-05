# $Id: gemspec 55 2006-08-16 22:04:22Z erikh $

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
  s.files            = FileList["{lib,test}/**/*"].to_a
  s.require_path     = "lib"
  s.test_file        = "test/tc_yamlconfig.rb"
  s.extra_rdoc_files = [ 'lib/LICENSE' ]
  s.has_rdoc         = true
end

