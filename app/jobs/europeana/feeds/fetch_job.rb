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

        if cached_feed.blank? || cached_feed.last_modified != @feed.last_modified
          Rails.cache.write(feed_cache_key, @feed)
          @updated = true
        end
      end
    end
  end
end
