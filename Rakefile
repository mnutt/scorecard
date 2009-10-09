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
require 'rspec-cukeapp'

task :default => 'spec:run'

PROJ.name = 'rspec-cukeapp'
PROJ.authors = 'Michael Nutt'
PROJ.email = 'michael@nuttnet.net'
PROJ.url = 'http://mnutt.github.com/cukeapp'
PROJ.version = RspecCukeapp::VERSION
PROJ.rubyforge.name = 'rspec-cukeapp'

PROJ.spec.opts << '--color'

# EOF
