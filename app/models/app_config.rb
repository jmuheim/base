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

  # See https://stackoverflow.com/questions/399447/how-to-implement-a-singleton-model
  def self.instance
    first_or_create!
  end

  def self.find(*args)
    instance
  end
end
