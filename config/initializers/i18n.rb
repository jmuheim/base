require 'i18n_missing_exception_handler'

I18n.exception_handler = I18n::MissingExceptionHandler.new
