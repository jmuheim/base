require 'rails_helper'

describe ApplicationHelper do
  describe '#icon' do
    describe '#icon(name)' do
      subject { icon 'not-ok' }

      it { should have_css 'span.glyphicon.glyphicon-not-ok' }
      it { should have_css 'span:empty' }
    end

    describe '#icon(name, content)' do
      subject { icon 'not-ok', 'This is the content' }
      it { should have_css 'span span.sr-only' }
      it { should have_content 'This is the content' }
    end

    describe '#icon(name, type: :fa)' do
      subject { icon 'not-ok', type: :fa }
      it { should have_css 'span.fa.fa-not-ok' }
      it { should have_css 'span:empty' }
    end

    describe '#icon(name, content, type: :fa)' do
      subject { icon('not-ok', 'This is the content', type: :fa) }
      it { should have_css 'span.fa.fa-not-ok' }
    end
  end

  describe '#flag' do
    describe '#flag(name)' do
      subject { flag 'ch' }

      it { should have_css 'span.glyphicon.bfh-flag-CH' }
      it { should have_css 'span:empty' }
    end

    describe '#flag(name, content)' do
      subject { flag 'not-ok', 'This is the content' }
      it { should have_css 'span span.sr-only' }
      it { should have_content 'This is the content' }
    end
  end

  describe '#sr_only' do
    describe '#sr_only(content)' do
      subject { sr_only 'This text is only for screen readers' }

      it { should have_css 'span.sr-only' }
      it { should have_content 'This text is only for screen readers' }
    end
  end

  describe '#yes_or_no' do
    describe '#yes_or_no(true)' do
      subject { yes_or_no true }

      it { should have_content 'Yes' }
    end

    describe '#yes_or_no(false)' do
      subject { yes_or_no false }

      it { should have_content 'No' }
    end
  end

  describe '#yes_or_no_icon' do
    describe '#yes_or_no_icon(true)' do
      subject { yes_or_no_icon true }

      it { should have_css 'span.glyphicon.glyphicon-ok' }
      it { should have_content 'Yes' }
    end

    describe '#yes_or_no_icon(false)' do
      subject { yes_or_no_icon false }

      it { should have_css 'span.glyphicon.glyphicon-remove' }
      it { should have_content 'No' }
    end
  end

  describe '#recurring_string?' do
    it 'returns whether an element is a sub sequent recurring occurrence of the very same object (namespaced by a namespace)' do
      expect(recurring_string?('hello',   'namespace')).to   eq '<span class="first_occurrence">hello</span>'
      expect(recurring_string?('hello 2', 'namespace')).to   eq '<span class="first_occurrence">hello 2</span>'
      expect(recurring_string?('hello 2', 'namespace 2')).to eq '<span class="first_occurrence">hello 2</span>'
      expect(recurring_string?('hello 2', 'namespace')).to   eq '<span class="recurrent_occurrence">hello 2</span>'
      expect(recurring_string?('hello',   'namespace')).to   eq '<span class="first_occurrence">hello</span>'
    end

    describe '#yes_or_no_icon(false)' do
      subject { yes_or_no_icon false }

      it { should have_css 'span.glyphicon.glyphicon-remove' }
      it { should have_content 'No' }
    end
  end

  describe '#home_link_class' do
    describe 'on home page' do
      let(:request) { double('request', path: '/en') }
      before  { allow(helper.request).to receive(:path).and_return request }
      subject { home_link_class }

      it { should eq ['navbar-brand', 'active'] }
    end

    describe 'on other page' do
      let(:request) { double('request', path: '/en/other') }
      before  { allow(helper.request).to receive(:path).and_return request }
      subject { home_link_class }

      it { should eq ['navbar-brand'] }
    end
  end

  describe '#active_class_for(language)' do
    describe 'same language' do
      subject { active_class_for(:en) }

      it { should eq 'active' }
    end

    describe 'other language' do
      subject { active_class_for(:de) }

      it { should be_nil }
    end
  end

  describe '#current_locale_flag' do
    subject { current_locale_flag }

    it { should have_content 'gb' }
  end

  describe '#container_for' do
    before { @user = create :user }

    describe '#container_for(object)' do
      subject { container_for(@user) { 'Some content' } }

      it { should have_css "div#user_#{@user.id}.user" }
      it { should have_content 'Some content' }
    end

    describe '#container_for(object, :tag)' do
      subject { container_for(@user, tag: 'article') { 'Some content' } }

      it { should have_css "article#user_#{@user.id}.user" }
    end
  end

  describe '#active_if_controller?' do
    describe '#active_if_controller?(current_controller)' do
      subject { active_if_controller?(:test) }

      it { should be :active }
    end

    describe '#active_if_controller?(some_controller, current_controller)' do
      subject { active_if_controller?(:some_controller, :test) }

      it { should be :active }
    end

    describe '#active_if_controller?(other_controller)' do
      subject { active_if_controller?(:not_test) }

      it { should be_nil }
    end
  end
end
