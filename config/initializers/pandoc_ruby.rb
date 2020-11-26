# On production server, Pandoc might not be in the standard path, so we are setting it here.

# It's a little workaround, see https://github.com/xwmx/pandoc-ruby/issues/40
PANDOC_PATH = if Rails.env.production?
                'pandoc' # Change if needed!
              else
                'pandoc'
              end

PandocRuby.pandoc_path = PANDOC_PATH
