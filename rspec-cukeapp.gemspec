# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-cukeapp}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Nutt"]
  s.date = %q{2009-10-08}
  s.default_executable = %q{rspec-cukeapp}
  s.description = %q{Provides an rspec output formatter that outputs html suitable for Cuke.app's display.}
  s.email = %q{michael@nuttnet.net}
  s.executables = ["rspec-cukeapp"]
  s.extra_rdoc_files = ["History.txt", "README.txt", "bin/rspec-cukeapp"]
  s.files = ["History.txt", "README.txt", "Rakefile", "bin/rspec-cukeapp", "lib/rspec-cukeapp.rb", "lib/rspec-cukeapp/cukeapp_formatter.rb", "rspec-cukeapp.gemspec", "spec/rspec-cukeapp_spec.rb", "spec/spec_helper.rb", "test/test_rspec-cukeapp.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://mnutt.github.com/cukeapp}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rspec-cukeapp}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Provides an rspec output formatter that outputs html suitable for Cuke}
  s.test_files = ["test/test_rspec-cukeapp.rb"]

  s.add_dependency("rspec", [">= 1.2.9"])

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.5.1"])
    else
      s.add_dependency(%q<bones>, [">= 2.5.1"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.5.1"])
  end
end
