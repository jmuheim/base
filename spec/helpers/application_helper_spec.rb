require 'rails_helper'

describe ApplicationHelper do
  describe '#icon(name)' do
    subject { icon 'not-ok' }

    it { should have_css 'span.glyphicon.glyphicon-not-ok' }
    it { should have_css 'span span.hide-text' }
    it { should have_content 'Not Ok' }
  end

  describe '#icon(name, content)' do
    subject { icon 'not-ok', 'This is the content' }
    it { should have_content 'This is the content' }
  end
end
