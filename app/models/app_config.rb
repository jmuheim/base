class AppConfig < ApplicationRecord
  has_paper_trail only: [ :app_abbreviation,
                          :app_name,
                          :app_slogan_de,
                          :app_slogan_en,
                          :organisation_name_de,
                          :organisation_name_en,
                          :organisation_abbreviation_de,
                          :organisation_abbreviation_en,
                          :organisation_url
                        ]

  extend Mobility
  translates :app_slogan, :organisation_name, :organisation_abbreviation

  validates :app_name, presence: true
  validates :app_slogan, presence: true
  validates :organisation_name, presence: true
  validates :organisation_abbreviation, presence: true
  validates :organisation_url, presence: true

  # See https://stackoverflow.com/questions/399447/how-to-implement-a-singleton-model
  def self.instance
    first_or_create! app_abbreviation: 'Base',
                     app_name: 'Base Project',
                     app_slogan_de: 'Vorkonfiguriertes grundlegendes zugängliches Rails Projekt. Fork erstellen!',
                     app_slogan_en: 'Pre-configured basic accessible Rails project. Fork me!',
                     organisation_name_de: 'Josua Muheim',
                     organisation_name_en: 'Josua Muheim',
                     organisation_abbreviation_de: 'JM',
                     organisation_abbreviation_en: 'JM',
                     organisation_url: 'https://github.com/jmuheim/base'
  end

  def self.find(*args)
    instance
  end
end
