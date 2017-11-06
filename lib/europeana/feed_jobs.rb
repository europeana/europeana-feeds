# frozen_string_literal: true

require 'active_job'
require 'feedjira'
require 'europeana/feeds/engine'

module Europeana
  module Feeds
    autoload :FetchJob, 'europeana/feeds/fetch_job'
  end
end
