# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FeedHelper do
  let(:feed_object) { double('dummy_feed_object', entries: %w(dummy_entry_1 dummy_entry_2)) }
  describe '#feed_entries' do
    it 'retrieves the cached feed' do
      expect(helper).to receive(:cached_feed).with('dummy_url') { feed_object }
      expect(helper.feed_entries('dummy_url')).to eq feed_object.entries
    end
  end

  describe '#cached_feed' do
    context 'when the feed has already been retrieved' do
      before do
        helper.instance_variable_set(:@cached_feeds, 'dummy_url' => feed_object)
      end

      it 'retruns the feed objcect without reading it from the cache' do
        expect(Rails.cache).not_to receive(:fetch)
        expect(helper.cached_feed('dummy_url')).to eq feed_object
      end
    end

    context 'when the feed has NOT yet been retrieved' do
      before do
        helper.instance_variable_set(:@cached_feeds, {})
      end

      it 'retruns the feed objcect by reading it from the cache' do
        expect(Rails.cache).to receive(:fetch).with('feed/dummy_url') { feed_object }
        expect(helper.cached_feed('dummy_url')).to eq feed_object
      end
    end
  end
end
