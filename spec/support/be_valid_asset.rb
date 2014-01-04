include BeValidAsset

BeValidAsset::Configuration.display_invalid_content = false
BeValidAsset::Configuration.display_invalid_lines = true
BeValidAsset::Configuration.display_invalid_lines_count = 7
BeValidAsset::Configuration.enable_caching = true
BeValidAsset::Configuration.cache_path = Rails.root.join('tmp', 'be_valid_asset_cache')

Slim::Engine.set_default_options pretty: true
