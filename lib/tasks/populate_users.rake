# frozen_string_literal: true
namespace :populate do
  desc 'Populate users with test data'
  task users: :environment do
    domain = ENV['LOCAL_DOMAIN'] || Rails.configuration.x.local_domain
    domain = domain.gsub(/:\d+$/, '')
    dummy_name = '10OctUser3'
    10.times do |i|
      i += 1
      account = Account.where(username: "#{dummy_name}#{i}").first_or_initialize(username: "#{dummy_name}#{i}")
      account.save(validate: false)

      user = User.where(email: "#{dummy_name}#{i}@#{domain}").first_or_initialize(
        email: "#{dummy_name}#{i}@#{domain}",
        password: 'password',
        password_confirmation: 'password',
        confirmed_at: Time.now.utc,
        role: nil,
        account: account,
        agreement: true,
        approved: true
      )
      user.save!
      user.approve!
      Rails.logger.info "Created user #{user.email} successfully"
    end
  end
end
