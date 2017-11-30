# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "fluent-plugin-twilio"
  s.version     = "0.1.0"
  s.authors     = ["Kentaro Yoshida"]
  s.email       = ["y.ken.studio@gmail.com"]
  s.homepage    = "https://github.com/y-ken/fluent-plugin-twilio"
  s.summary     = %q{Fluentd Output plugin to make a phone call with Twilio VoIP API. Twiml supports text-to-speech with many languages ref. https://www.twilio.com/docs/api/twiml/say}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit", ">= 3.1.0"
  s.add_runtime_dependency "fluentd", ">= 0.14.15", "< 2"
  s.add_runtime_dependency "twilio-ruby", "~> 5.5.0"
end
