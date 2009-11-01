# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'spec'
require 'scorecard'

task :default => 'spec:run'

PROJ.name = 'scorecard'
PROJ.authors = 'Michael Nutt'
PROJ.email = 'michael@nuttnet.net'
PROJ.url = 'http://mnutt.github.com/scorecard'
PROJ.version = Scorecard::VERSION
PROJ.rubyforge.name = 'scorecard'

PROJ.spec.opts << '--color'

# EOF
