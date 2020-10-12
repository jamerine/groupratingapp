namespace :run do
  desc 'Task to open some sidekiq windows locally'
  task startup_sidekiq: :environment do
    puts execute('$PWD')
    execute('osascript $PWD/lib/tasks/sidekiq/local_startup.scpt')
  end
end

def execute(cmd)
  puts "---> Executing '#{cmd}'..."
  system cmd
end