require 'rails_helper'

describe 'Editing app config' do
  before do
    @admin = create :user, :admin
    login_as(@admin)

    @app_config = AppConfig.instance
  end

  it 'grants permission to edit a page' do
    visit edit_app_config_path(@app_config)

    expect(page).to have_title 'Edit Application configuration - Base'
    expect(page).to have_active_navigation_items 'Application configuration'
    expect(page).to have_breadcrumbs 'Base', 'Application configuration', 'Edit'
    expect(page).to have_headline 'Edit Application configuration'

    expect(page).to have_css 'h2', text: 'Details'

    fill_in 'app_config_organisation_name', with: 'Much cooler name'
    fill_in 'app_config_organisation_abbreviation', with: 'Much cooler abbreviation'
    fill_in 'app_config_organisation_url', with: 'Much cooler URL'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Update Application configuration'
      expect(page).not_to have_link 'List of Application configuration'
    end

    expect {
      click_button 'Update Application configuration'
      @app_config.reload
    } .to  change { @app_config.organisation_name }.to('Much cooler name')
      .and change { @app_config.organisation_abbreviation }.to('Much cooler abbreviation')
      .and change { @app_config.organisation_url }.to('Much cooler URL')
  end

  it "prevents from overwriting other users' changes accidently (caused by race conditions)" do
    visit edit_app_config_path(@app_config)

    # Change something in the database...
    expect {
      @app_config.update_attributes organisation_name: 'This is the old organisation name'
    }.to change { @app_config.lock_version }.by 1

    fill_in 'app_config_organisation_name', with: 'This is the new organisation name, yeah!'

    expect {
      click_button 'Update Application configuration'
      @app_config.reload
    }.not_to change { @app_config }

    expect(page).to have_flash('Alert: Application configuration meanwhile has been changed. The conflicting field is: Organisation name.').of_type :alert

    expect {
      click_button 'Update Application configuration'
      @app_config.reload
    } .to change { @app_config.organisation_name }.to('This is the new organisation name, yeah!')
  end

  it 'allows to translate a page to German' do
    @app_config.update_attributes organisation_abbreviation_de: nil
    visit edit_app_config_path @app_config, locale: :de # Default locale (English)

    expect(page).to have_css 'input#app_config_organisation_abbreviation[value="TRANSLATION MISSING"]'
    fill_in 'app_config_organisation_abbreviation', with: 'ZFA'

    expect {
      click_button 'Applikations-Konfiguration aktualisieren'
      @app_config.reload
    } .to  change { @app_config.organisation_abbreviation }.from('TRANSLATION MISSING').to('ZFA')
      .and change { @app_config.organisation_abbreviation_de }.from(nil).to('ZFA')
    expect(@app_config.organisation_abbreviation_en).to eq 'JM'

    expect(page).to have_flash 'Applikations-Konfiguration wurde erfolgreich bearbeitet.'
  end
end
