SidekiqBasicAuth = proc do |username, password|
  require 'digest'

  username_compare = ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(username),
    ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD'])
  )
  password_compare = ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(password),
    ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD'])
  )
  username_compare | password_compare
end
