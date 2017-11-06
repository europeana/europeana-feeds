# frozen_string_literal: true

module Europeana
  module Feeds
    class Engine < Rails::Engine
      isolate_namespace Europeana::Feeds

      engine_name 'europeana_feeds'

      config.generators do |g|
        g.test_framework :rspec
      end

      config.autoload_paths += %W(
        #{config.root}
      )
    end
  end
end
