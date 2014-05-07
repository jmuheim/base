BowerRails.configure do |bower_rails|
  # Don't use resolving relative paths for now, see https://github.com/jmuheim/base/pull/35 and https://github.com/42dev/bower-rails/issues/79.
  # bower_rails.resolve_before_precompile = true # Invokes rake bower:resolve before precompilation
end
