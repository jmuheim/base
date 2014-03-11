# Easy error rescuing, see https://github.com/mirego/gaffe

Gaffe.configure do |config|
  config.errors_controller = ErrorsController
end
Gaffe.enable!
