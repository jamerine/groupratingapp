namespace :process do
  desc "This task is called by cron on Fridays at 8pm to import miras/clicds"
  task mira_clicds: :environment do
    MiraClicdProcess.perform_async
  end
end