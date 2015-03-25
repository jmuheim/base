require 'ya2yaml'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/keys'
require 'i18n'

module I18n
  class MissingExceptionHandler < I18n::ExceptionHandler
    MISSING_TRANSLATIONS_PATH = 'config/missing_translations.yml'

    def call(exception, locale, key, options)
      if exception.is_a?(I18n::MissingTranslation)
        keys = I18n.normalize_keys(locale, key, options[:scope])
        missing_translations << keys unless missing_translations.contains?(keys)
        super
      end
    end

    def missing_translations?
      missing_translations.any?
    end

    def missing_translations
      @missing_translations ||= []
    end

    def clear_missing_translations
      @missing_translations = []
    end

    def missing_translations_to_hash(locale=nil)
      result_hash = {}
      missing_translations.uniq.each do |key|
        next if locale and key[0] != locale.to_sym
        hash = ""
        key.reverse.each { |key| hash = { key => hash } }
        result_hash = result_hash.deep_merge(hash)
      end
      result_hash
    end

    def store_missing_translations
      if missing_translations?
        file = File.open(MISSING_TRANSLATIONS_PATH, 'w+')
        file.write(missing_translations_to_hash(I18n.default_locale).deep_stringify_keys.ya2yaml)
        file.close

        clear_missing_translations
      end
    end
  end
end
