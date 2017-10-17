# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Europeana::FeedJobs::FeedEntryImage do
  let(:feed_entry) { double('dummy_feed_entry', image: 'dummy_image') }
  let(:dummy_file) { double('dummy_file', url: 'computed_url') }

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

  describe '#thumbnail_url' do
    context 'when MediaObject is NOT defined' do
      it 'returns the thumbnail url' do
        expect(subject.thumbnail_url).to eq('dummy_image')
      end
    end

    context 'when MediaObject IS defined' do
      before do
        class MediaObject
          def initialize(dummy_file)
            @dummy_file = dummy_file
          end

          def file
            @dummy_file
          end
        end
        allow(subject).to receive(:media_object) { media_object }
        allow(subject).to receive(:media_object_url) { 'dummy_url' }
      end

      after do
        Object.send(:remove_const, :MediaObject)
      end

      let(:media_object) { MediaObject.new(dummy_file) }

      it 'returns the computed url' do
        expect(subject.thumbnail_url).to eq('computed_url')
      end
    end
  end

  describe '#media_object' do
    context 'when MediaObject is NOT defined' do
      it 'returns the thumbnail' do
        expect(subject.media_object).to eq('dummy_image')
      end
    end

    context 'when MediaObject IS defined' do
      before do
        class MediaObject
          def initialize(dummy_file)
            @dummy_file = dummy_file
          end

          def file
            @dummy_file
          end

          def self.hash_source_url(_url)
            'QWERTYUIOP123456789POIUYTREWQ'
          end
        end

        allow(MediaObject).to receive(:find_by_source_url_hash) { media_object }
        allow(subject).to receive(:media_object_url) { 'dummy_url' }
      end

      after do
        Object.send(:remove_const, :MediaObject)
      end

      let(:media_object) { MediaObject.new(dummy_file) }

      it 'returns the computed url' do
        expect(subject.media_object).to eq(media_object)
      end
    end
  end

  describe '#initialize' do
    it 'sets @feed_entry' do
      expect(subject.instance_variable_get(:@feed_entry)).to eq(feed_entry)
    end
  end
end
