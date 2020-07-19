require 'rails_helper'

describe ApplicationController do
  describe '#pandoc_version' do
    it 'returns the version' do
      expect(controller.send :pandoc_version).to be > 0
    end
  end
end
