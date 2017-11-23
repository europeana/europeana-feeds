# frozen_string_literal: true

module Europeana
  module Feeds
    class FetchJob < ActiveJob::Base
      queue_as :feeds

      def perform(url)
        @url = url

        @feed = ::Feedjira::Feed.fetch_and_parse(@url)

        feed_cache_key = "feed/#{@url}"
        cached_feed = Rails.cache.fetch(feed_cache_key)

        if modified?(cached_feed)
          Rails.cache.write(feed_cache_key, @feed)
          @updated = true
        end
      end

      def modified?(cached_feed)
        if cached_feed.blank?
          true
        elsif @feed.last_built
          cached_feed.last_built != @feed.last_built
        elsif @feed.last_modified
          cached_feed.last_modified != @feed.last_modified
        else
          # When the feed doesn't specify a build date or modified date,
          # assume it's been modified.
          true
        end
      end
    end
  end
end
