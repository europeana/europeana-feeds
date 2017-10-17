# frozen_string_literal: true

module Europeana
  module FeedJobs
    class Engine < Rails::Engine
      isolate_namespace Europeana::FeedJobs

      engine_name 'europeana_feed_jobs'

      config.generators do |g|
        g.test_framework :rspec
      end

      config.autoload_paths += %W(
        #{config.root}
      )
    end
  end
end
