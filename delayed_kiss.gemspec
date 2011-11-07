# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "delayed_kiss/version"

Gem::Specification.new do |s|
  s.name        = "delayed_kiss"
  s.version     = DelayedKiss::VERSION
  s.authors     = ["Dustin DeYoung"]
  s.email       = ["ddeyoung@authorsolutions.com"]
  s.homepage    = ""
  s.summary     = %q{KissMetrics API with Delayed Job}
  s.description = %q{A simple wrapper for the KissMetrics API using Delayed Job}

  s.rubyforge_project = "delayed_kiss"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("activesupport")
  s.add_dependency("i18n")
  s.add_dependency("httparty", ">= 0.8.1")
  s.add_dependency("delayed_job", ">= 2.1.4")
end
