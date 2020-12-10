require 'rails_helper'

RSpec.describe AppConfig do
  describe 'validations' do
    it { should validate_presence_of :app_name }
    it { should validate_presence_of :app_slogan }
    it { should validate_presence_of :organisation_name }
    it { should validate_presence_of :organisation_abbreviation }
    it { should validate_presence_of :organisation_url }
  end

  it 'provides optimistic locking' do
    app_config = AppConfig.instance
    stale_app_config = AppConfig.find(AppConfig.instance.id)

    app_config.update_attribute :app_name, 'new-name'

    expect {
      stale_app_config.update_attribute :app_name, 'even-newer-name'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    describe 'attributes' do
      before { @app_config = AppConfig.instance }

      it 'versions app_name' do
        expect {
          @app_config.update_attributes! app_name: 'New app_name'
        }.to change { @app_config.versions.count }.by 1
      end

      it 'versions app_slogan (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @app_config.update_attributes! "app_slogan_#{locale}" => 'New app_slogan'
          }.to change { @app_config.versions.count }.by 1
        end
      end

      it 'versions organisation_name (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @app_config.update_attributes! "organisation_name_#{locale}" => 'New organisation_name'
          }.to change { @app_config.versions.count }.by 1
        end
      end

      it 'versions organisation_abbreviation (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @app_config.update_attributes! "organisation_abbreviation_#{locale}" => 'New organisation_abbreviation'
          }.to change { @app_config.versions.count }.by 1
        end
      end

      it 'versions organisation_url' do
        expect {
          @app_config.update_attributes! organisation_url: 'New organisation_url'
        }.to change { @app_config.versions.count }.by 1
      end
    end
  end

  describe 'translating' do
    before { @app_config = AppConfig.instance }

    it 'translates app_slogan' do
      expect {
        Mobility.with_locale(:de) { @app_config.update_attributes! app_slogan: 'Deutscher app_slogan' }
        @app_config.reload
      }.not_to change { @app_config.app_slogan }
      expect(@app_config.app_slogan_de).to eq 'Deutscher app_slogan'
    end

    it 'translates organisation_name' do
      expect {
        Mobility.with_locale(:de) { @app_config.update_attributes! organisation_name: 'Deutscher organisation_name' }
        @app_config.reload
      }.not_to change { @app_config.organisation_name }
      expect(@app_config.organisation_name_de).to eq 'Deutscher organisation_name'
    end

    it 'translates organisation_abbreviation' do
      expect {
        Mobility.with_locale(:de) { @app_config.update_attributes! organisation_abbreviation: 'Deutscher organisation_abbreviation' }
        @app_config.reload
      }.not_to change { @app_config.organisation_abbreviation }
      expect(@app_config.organisation_abbreviation_de).to eq 'Deutscher organisation_abbreviation'
    end
  end
end
