# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Europeana::Feeds do
  it 'has a version number' do
    expect(Europeana::Feeds::VERSION).not_to be nil
  end
end
