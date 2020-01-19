Rails.application.routes.draw do
  get 'clans/:clan_tag' => 'activity#clan_war_activity'

  require 'sidekiq/web'
  Sidekiq::Web.use(Rack::Auth::Basic, &SidekiqBasicAuth) if Rails.env.production?
  mount Sidekiq::Web, at: '/sidekiq'
end
