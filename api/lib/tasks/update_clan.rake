namespace :update_clan do
  desc 'Update clan Members'
  task :members, [:clan_tag] => :environment do |_task, args|
    clan_tag = args[:clan_tag]
    ClanDataUpdater::ClanMembersWorker.perform_async(clan_tag)
  end
end
