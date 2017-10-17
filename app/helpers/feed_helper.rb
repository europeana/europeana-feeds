# frozen_string_literal: true

module FeedHelper
  def feed_entries(url)
    feed = cached_feed(url)
    feed.present? ? feed.entries : []
  end

  def cached_feed(url)
    @cached_feeds ||= {}
    @cached_feeds[url] ||= begin
      Rails.cache.fetch("feed/#{url}")
    end
  end

  # entry [Feedjira::Parser::RSSEntry]
  def feed_entry_thumbnail_url(entry)
    Europeana::FeedJobs::FeedEntryImage.new(entry).thumbnail_url
  end

  ##
  # Tries to retrieve a cached feed and formats it for display.
  def feed_items_for(url)
    cached_feed = cached_feed(url)

    return [] if cached_feed.blank? || cached_feed.entries.blank?

    cached_feed.entries.map do |item|
      {
        url: CGI.unescapeHTML(item.url),
        img: {
          src: feed_entry_thumbnail_url(item),
          alt: item.title
        },
        title: item.title,
        date: I18n.l(item.published, format: :short).gsub(/\s00:00$/, ''),
        published: item.published,
        excerpt: {
          short: strip_tags(CGI.unescapeHTML(item.summary.to_s))
        },
        type: detect_feed_type(feed)
      }
    end
  end
end
