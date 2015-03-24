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

  describe '#container_for(object)' do
    subject { container_for(user = create(:user)) { 'Some content' } }

    it { should have_css 'div#user_1.user' }
    it { should have_content 'Some content' }
  end

  describe '#container_for(object, :tag)' do
    subject { container_for(create(:user), tag: 'article') { 'Some content' } }

    it { should have_css 'article#user_1.user' }
  end
end
