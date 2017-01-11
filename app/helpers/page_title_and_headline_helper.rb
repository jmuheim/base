# Helps managing uniform page title, headline, and flash messages.
#
# It assumes that there's always a main `h1` tag (the headline) which identifies the main content of the page (typically this would be the first `h1` tag within the `main` tag), and that this headline should reflect the content of the `title` tag.
#
# It furthermore assumes that flash messages are always related to the main content and therefore are displayed right after the headline.
#
# For accessibility reasons, the `title` tag should consist of the following:
#
# - Flash messages (if there are any)
# - The headline
# - The app's name (except on the home page, which's headline typically already contains the app's name)
#
# If more details are needed in the title than the headline provides, it can be prefixed with more info.
module PageTitleAndHeadlineHelper
  # Displays the current headline, followed by flash messages.
  #
  # Accepts parameter for customizing/replacing the headline, or simply looks up `.title` when no parameters given.
  #
  # Examples:
  #
  # - `headline_with_flash` simply translates `.title`
  # - `headline_with_flash(key: 'value')` passes the provided keys to the translation of `.title`
  # - `headline_with_flash('My title')` uses the given string (instead of translating `.title`)
  def headline_with_flash(*args)
    options = args.extract_options!
    heading = args[0]
    raise "You can't provide both a heading and options!" if heading && options.any?

    @headline = heading.nil? ? default_headline(options) : heading
    @title = @headline

    # Tabindex is required so the focus is really set to the element when using the jump link
    content_tag :div, id: 'headline' do
      content_tag(:h1, @headline, id: 'headline_title', tabindex: -1) + flash_messages(flash)
    end
  end

  # Generates the flash messages HTML structure.
  def flash_messages(flash)
    flash.map do |name, message|
      classes = ['alert', "alert-#{name == 'notice' ? 'success' : 'danger'}"]
      translated_flash_name = t "flash.#{name}"

      content_tag :div, class: classes do
        message = content_tag :p, "#{translated_flash_name}: #{message}", id: "flash", class: "flash-#{name}"

        button = content_tag :button, class: 'close', type: 'button', data: {dismiss: 'alert'} do
                   icon :remove, t('flash.close', name: translated_flash_name)
                 end

        message + button
      end
    end.join.html_safe
  end

  # Generates a title tag, consisting of potential flash messages, the page's headline, and the app's name (except when on root path).
  def title_tag
    content_tag :title do
      parts = []
      parts += flash.map { |key, value| "#{t "flash.#{key}"}: #{value}" } if flash.any?
      parts << @title
      parts << "- #{t('app.acronym')}" unless current_page?(root_path)
      parts.join ' '
    end
  end

  # Returns the current headline (be sure to call #headline_with_flash first).
  def headline
    @headline or raise 'No page heading provided! Be sure to call #headline_with_flash first.'
  end

  # Can be used to prefix the title with additional content. Returns the given prefix.
  def title_prefix(prefix)
    @title = "#{prefix} - #{@title}" if headline
    prefix
  end

  # Returns the default headline (can be overriden in controllers).
  def default_headline(options = {})
    t '.title', options
  end
end
