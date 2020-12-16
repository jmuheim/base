# On production server, Pandoc might not be in the standard path, so we are setting it here.

# It's a little workaround, see https://github.com/xwmx/pandoc-ruby/issues/40
PANDOC_PATH = if Rails.env.production?
                'pandoc' # Change if needed!
              else
                'pandoc'
              end

PandocRuby.pandoc_path = PANDOC_PATH

# Maybe there is a more elegant option?
# See https://stackoverflow.com/questions/65319978/pandocruby-set-default-options-so-they-will-be-used-whenever-i-call-convert
PANDOC_OPTIONS = {f: 'markdown-raw_html'}
