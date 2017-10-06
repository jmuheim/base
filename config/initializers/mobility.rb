Mobility.configure do |config|
  config.default_backend = :column
  config.accessor_method = :translates
  config.query_method    = :i18n

  config.default_options = {
    dirty: true,
    fallbacks: { de: :en,
                 en: :de }
  }
end
