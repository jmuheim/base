require 'rails_helper'

describe ApplicationController do
  controller(ApplicationController) do
    def index
      render body: 'Hello World'
    end
  end

  describe 'locale parameter' do
    it 'is set to english when not available in the request' do
      get :index
      expect(I18n.locale).to eq :en
    end

    it 'can be set through the request' do
      get :index, params: {locale: :de}
      expect(I18n.locale).to eq :de
    end
  end
end
