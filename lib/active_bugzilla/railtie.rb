require 'rails'

module ActiveBugzilla
  class Railtie < ::Rails::Railtie
    config.active_bugzilla = ActiveSupport::OrderedOptions.new

    config.before_configuration do
      config.active_bugzilla[:bugzilla_uri]      ||= ENV['BUGZILLA_URI']
      config.active_bugzilla[:bugzilla_username] ||= ENV['BUGZILLA_USERNAME']
      config.active_bugzilla[:bugzilla_password] ||= ENV['BUGZILLA_PASSWORD']
    end

    initializer 'active_bugzilla.configure' do |app|
      uri      = app.config.active_bugzilla[:bugzilla_uri]
      username = app.config.active_bugzilla[:bugzilla_username]
      password = app.config.active_bugzilla[:bugzilla_password]

      ::ActiveBugzilla::Base.connect!(uri, username, password)
    end

    rake_tasks do
      namespace :bugzilla do
        desc "Test your ActiveBugzilla base connection by getting the Bugzilla host version"
        task :version => :environment do
          puts ActiveBugzilla.execute('Bugzilla.version', {})['version']
        end
      end
    end
  end
end
