# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Europeana::Feeds::FetchJob do
  before(:each) do
    ActiveJob::Base.queue_adapter = :test
    stub_request(:get, url).
      to_return(body: rss_body,
                status: 200,
                headers: { 'Content-Type' => 'application/rss+xml' })
  end

  let(:url) { 'http://blog.europeana.eu/all' }
  let(:rss_body) do
    <<~FEEDXML
      <?xml version="1.0"?>
      <rss version="2.0">
      <channel>
        <title>Example Channel</title>
        <link>http://example.com/</link>
        <description>My example channel</description>
        <lastBuildDate>Mon, 22 May 2017 00:00:00 +0000</lastBuildDate>
        <item>
           <title>Example item</title>
           <link>http://example.com/item</link>
           <description>About the example item...</description>
           <content:encoded><![CDATA[<img src="http://www.example.com/image.png"/>]]></content:encoded>
           <pubDate>Mon, 22 May 2017 00:00:00 +0000</pubDate>
        </item>
      </channel>
      </rss>
    FEEDXML
  end
  subject { described_class.new }

  it 'responds to perform' do
    expect(subject).to respond_to(:perform)
  end
  let(:cache_key) { "feed/#{url}" }

  it 'should fetch an HTTP feed' do
    subject.perform(url)
    expect(a_request(:get, url)).to have_been_made.at_least_once
  end

  it 'should cache the feed' do
    Rails.cache.delete(cache_key)
    described_class.perform_now(url)
    cached = Rails.cache.fetch(cache_key)
    expect(cached).to be_a(::Feedjira::Parser::RSS)
    expect(cached.feed_url).to eq(url)
  end

  context 'when the feed was previously cached' do
    before do
      Rails.cache.write(cache_key, ::Feedjira::Feed.parse(rss_body))
    end

    context 'when the last_modified date has NOT changed' do
      it 'should not update the cache and @updated should be false' do
        expect(Rails.cache).to_not receive(:write)
        subject.perform(url)
        expect(subject.instance_variable_get(:@updated)).to_not eq(true)
      end
    end

    context 'when the last_built date has changed' do
      before do
        Rails.cache.write(cache_key, ::Feedjira::Feed.parse(rss_body.gsub('<lastBuildDate>Mon, 22 May 2017', '<lastBuildDate>Tue, 23 May 2017')))
      end

      it 'should update the cache and @updated should be true' do
        expect { subject.perform(url) }.to change { Rails.cache.fetch(cache_key) }
        expect(subject.instance_variable_get(:@updated)).to eq(true)
      end
    end

    context 'when the feed does NOT have a build date' do
      let(:rss_body) do
        <<~FEEDXML
      <?xml version="1.0"?>
      <rss version="2.0">
      <channel>
        <title>Example Channel</title>
        <link>http://example.com/</link>
        <description>My example channel</description>
        <item>
           <title>Example item</title>
           <link>http://example.com/item</link>
           <description>About the example item...</description>
           <content:encoded><![CDATA[<img src="http://www.example.com/image.png"/>]]></content:encoded>
           <pubDate>Mon, 22 May 2017 00:00:00 +0000</pubDate>
        </item>
      </channel>
      </rss>
        FEEDXML
      end

      context 'when the last_modified date has NOT changed' do
        before do
          Rails.cache.write(cache_key, ::Feedjira::Feed.parse(rss_body))
        end

        it 'should not update the cache and @updated should be false' do
          expect(Rails.cache).to_not receive(:write)
          subject.perform(url)
          expect(subject.instance_variable_get(:@updated)).to_not eq(true)
        end
      end

      context 'when the last_modified date has changed' do
        before do
          Rails.cache.write(cache_key, ::Feedjira::Feed.parse(rss_body.gsub('<pubDate>Mon, 22 May 2017', '<pubDate>Tue, 23 May 2017')))
        end

        it 'should update the cache and @updated should be true' do
          expect { subject.perform(url) }.to change { Rails.cache.fetch(cache_key) }
          expect(subject.instance_variable_get(:@updated)).to eq(true)
        end
      end
    end
  end
end
