# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Europeana::Feeds::FeedEntryImage do
  let(:feed_entry) { double('dummy_feed_entry', image: 'dummy_image') }

  subject { described_class.new(feed_entry) }

  describe 'entry elements' do
    it 'uses summary and content' do
      expect(described_class::ENTRY_ELEMENTS).to eq(%i(summary content))
    end
  end

  describe 'tag attributes' do
    it 'uses src for img and poster for video tags' do
      expect(described_class::TAGS_ATTRS).to eq([{ tag: :img, attr: :src }, { tag: :video, attr: :poster }])
    end
  end

  describe '#initialize' do
    it 'sets @feed_entry' do
      expect(subject.instance_variable_get(:@feed_entry)).to eq(feed_entry)
    end
  end
end
