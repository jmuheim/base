require 'rails_helper'

describe HomepageController do
  # This is vicarious for any sub controller of ApplicationController
  describe 'locale parameter' do
    it 'is set to english when not available in the request' do
      get :show
      expect(I18n.locale).to eq :en
    end

    it 'can be set through the request' do
      get :show, params: {locale: :de}
      expect(I18n.locale).to eq :de
    end
  end
end
