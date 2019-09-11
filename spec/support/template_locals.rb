# See https://github.com/rspec/rspec-rails/issues/1219 and https://gist.github.com/codebeige/86905eb7dd7cef33230223ae456fe2f0
module TemplateLocals
  def assign_locals(locals)
    @_default_locals = _default_locals.merge locals
  end

  private

  def _default_locals
    @_default_locals || {}
  end

  def _default_render_options
    super.merge locals: _default_locals
  end
end

RSpec.configure do |config|
  config.include TemplateLocals, type: :view
end
