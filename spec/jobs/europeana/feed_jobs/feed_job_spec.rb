# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Europeana::FeedJobs::FeedJob do
  subject { described_class.new }

  it 'responds to perform' do
    expect(subject).to respond_to(:perform)
  end
end
