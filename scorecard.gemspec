# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scorecard}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Nutt"]
  s.date = %q{2009-10-08}
  s.default_executable = %q{scorecard}
  s.description = %q{Provides an rspec output formatter that outputs html suitable for Scorecard.app's display.}
  s.email = %q{michael@nuttnet.net}
  s.executables = ["scorecard"]
  s.extra_rdoc_files = ["History.txt", "README.txt", "bin/scorecard"]
  s.files = ["History.txt", "README.txt", "Rakefile", "bin/scorecard", "lib/scorecard.rb", "lib/scorecard/formatter.rb", "scorecard.gemspec", "spec/scorecard_spec.rb", "spec/spec_helper.rb", "test/test_scorecard.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://mnutt.github.com/scorecard}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{scorecard}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Provides an rspec output formatter that outputs json suitable for Scorecard.app}
  s.test_files = ["test/test_scorecard.rb"]

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
