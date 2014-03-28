# Poltergeist hack to silence CoreText performance notes from phantomjs.
# May become obsolete when this is merged: https://github.com/boxen/puppet-phantomjs/pull/14
#
# See https://gist.github.com/ericboehs/7125105
module Capybara::Poltergeist
  class Client
    private
    def redirect_stdout
      prev = STDOUT.dup
      prev.autoclose = false
      $stdout = @write_io
      STDOUT.reopen(@write_io)

      prev = STDERR.dup
      prev.autoclose = false
      $stderr = @write_io
      STDERR.reopen(@write_io)
      yield
    ensure
      STDOUT.reopen(prev)
      $stdout = STDOUT
      STDERR.reopen(prev)
      $stderr = STDERR
    end
  end
end

class WarningsSuppressor
  IGNORES = [
    /QFont::setPixelSize: Pixel size <= 0/,
    /CoreText performance note:/
  ]

  class << self
    def write(message)
      if suppress?(message)
        0
      else
        puts(message)
        1
      end
    end

    private

    def suppress?(message)
      IGNORES.any? { |re| message =~ re }
    end
  end
end