require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = '1'
  ENV['RESQUE_TERM_TIMEOUT'] = '10'
end

QUEUE=* rake environment resque:work

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
