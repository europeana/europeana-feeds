# frozen_string_literal: true

require 'active_job'
require 'europeana/feed_jobs/engine'

module Europeana
  module FeedJobs
    autoload :FeedJob, 'europeana/feed_jobs/feed_job'
  end
end
