# frozen_string_literal: true

require 'active_job'
require 'feedjira'
require 'europeana/feed_jobs/engine'

module Europeana
  module FeedJobs
    autoload :FeedJob, 'europeana/feed_jobs/feed_job'
  end
end
