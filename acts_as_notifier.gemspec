$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_notifier/version"

Gem::Specification.new do |spec|
  spec.name          = "acts_as_notifier"
  spec.version       = ActsAsNotifier::VERSION
  spec.authors       = ["mtjhax"]
  spec.description   = <<-EOF
    acts_as_notifier is an add-on for ActiveRecord models used to notify users of new and updated records
    via ActionMailer emails. The notifications can be make conditional and recipient lists can be specified
    at runtime using a proc or method name. acts_as_notifier can be configured to send emails via DelayedJob.
  EOF
  spec.summary       = %q{Easily define ActiveRecord callbacks that notify users of changes via email.}
  spec.license       = "MIT"

  # bundler style:
  #spec.files         = `git ls-files`.split($/)
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  # Rails style:
  spec.files         = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  spec.test_files    = Dir["test/**/*"]

  #spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails", "~> 3.2.16"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "mocha"
  spec.add_runtime_dependency "activesupport", ">= 3.2.0"
  spec.add_runtime_dependency "activerecord", ">= 3.2.0"
end
