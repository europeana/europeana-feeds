# frozen_string_literal: true

module Europeana
  module FeedJobs
    class FeedJob < ActiveJob::Base
      queue_as :cache

      def perform(url, download_media = false)
        @url = url
        @download_media = download_media

        @feed = Feedjira::Feed.fetch_and_parse(@url)

        feed_cache_key = "feed/#{@url}"
        cached_feed = Rails.cache.fetch(feed_cache_key)

        if cached_feed.blank? || cached_feed.last_modified != @feed.last_modified
          Rails.cache.write(feed_cache_key, @feed)
          @updated = true
        end
      end

      # Global nav uses some feeds, and is cached so needs to be expired when those
      # feeds are updated.
      # Cached pages need to be expired should they be using the updated feed.
      after_perform do
        return unless @updated
        if @download_media && defined? ::DownloadRemoteMediaObjectJob
          @feed.entries.each do |entry|
            img_url = FeedEntryImage.new(entry).media_object_url
            ::DownloadRemoteMediaObjectJob.perform_later(img_url) unless img_url.nil?
          end
        end
        ::Cache::Expiry::FeedAssociatedJob.perform_later(@url) if defined? ::Cache::Expiry::FeedAssociatedJob
      end
    end
  end
end
