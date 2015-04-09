# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion-resource/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "motion-resource"
  s.version     = MotionResource::VERSION
  s.authors     = ["Thomas Kadauke"]
  s.email       = ["thomas.kadauke@googlemail.com"]
  s.homepage    = "https://github.com/tkadauke/motion-resource"
  s.summary     = "Access RESTful resources from your iOS app"
  s.description = "Access RESTful resources from your iOS app. Inspired by ActiveResource."

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'bubble-wrap'
  s.add_dependency 'afmotion', ">= 2.1.0"
  s.add_dependency 'motion-support', '>= 0.2.6'
  s.add_development_dependency 'rake'
end
