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

  describe '#yes_or_no_icon' do
    describe '#yes_or_no_icon(true)' do
      subject { yes_or_no_icon true }

      it { should have_content 'Yes' }
    end

    describe '#yes_or_no_icon(false)' do
      subject { yes_or_no_icon false }

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

  describe '#active_class_for(locale)' do
    describe 'same locale' do
      subject { active_class_for(:en) }

      it { should eq 'active' }
    end

    describe 'other locale' do
      subject { active_class_for(:de) }

      it { should be_nil }
    end
  end

  describe '#current_locale_flag' do
    subject { current_locale_flag }

    it { should have_content 'gb' }
  end

  describe '#locale_flag' do
    describe 'german' do
      subject { locale_flag :de }

      it { should have_content 'de' }
    end

    describe 'english' do
      subject { locale_flag :en }

      it { should have_content 'gb' }
    end
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

  describe "#complete_internal_references" do
    before { @creator = create :user }

    context 'replacing page references' do
      before { @page = create(:page, creator: @creator) }

      it 'converts @references to page ids to full page paths (e.g. @page-123)' do
        @page.update_attribute :content, "[](@page-#{@page.id})"
        expect(complete_internal_references(@page, :content)).to eq "[Page test title](/en/pages/#{@page.id}){.page}"
      end

      it "doesn't take into account references that miss the @ (e.g. page-123)" do
        @page.update_attribute :content, "[](page-#{@page.id})"
        expect(complete_internal_references(@page, :content)).to eq @page.content
      end

      it "fails gracefully if page id doesn't exist" do
        @page.update_attribute :content, "[Some alt](@page-123)"
        expect(complete_internal_references(@page, :content)).to eq "[Some alt](@page-123)"
      end

      it 'replaces empty alt text with the page title' do
        @page.update_attribute :content, "[](@page-#{@page.id})"
        expect(complete_internal_references(@page, :content)).to eq "[Page test title](/en/pages/#{@page.id}){.page}"
      end

      context 'alt text different to page title' do
        it 'adds the page title as title attribute' do
          @page.update_attribute :content, "[some other title](@page-#{@page.id})"
          expect(complete_internal_references(@page, :content)).to eq "[some other title](/en/pages/#{@page.id}){.page title=\"Page test title\"}"
        end
      end

      context 'alt text equals page title' do
        it "doesn't add title as title attribute" do
          @page.update_attribute :content, "[Page test title](@page-#{@page.id})"
          expect(complete_internal_references(@page, :content)).to eq "[Page test title](/en/pages/#{@page.id}){.page}"
        end
      end
    end

    context 'replacing image references' do
      before { @page = create(:page, creator: @creator, images: [create(:image, creator: @creator)]) }

      it 'converts @references to image identifiers to full image paths (e.g. @image-test-123)' do
        @page.update_attribute :content, "![My image](@image-Image test identifier)"
        expect(complete_internal_references(@page, :content)).to eq "![My image](/uploads/image/file/#{@page.images.first.id}/image.jpg){.image}"
      end

      it "doesn't take into account references that miss the @ (e.g. image-test-123)" do
        @page.update_attribute :content, "[](image-Image test identifier)"
        expect(complete_internal_references(@page, :content)).to eq "[](image-Image test identifier)"
      end

      it "fails gracefully if image identifier doesn't exist" do
        @page.update_attribute :content, "[Some alt](@image-inexistant)"
        expect(complete_internal_references(@page, :content)).to eq "[Some alt](@image-inexistant)"
      end

      it "only replaces identifiers of own images" do
        other_page = create :page, title: 'Other page', creator: @creator, images: [create(:image, identifier: 'other-identifier', creator: @creator)]

        @page.update_attribute :content, "![My image](@image-other-identifier)"
        expect(complete_internal_references(@page, :content)).to eq "![My image](@image-other-identifier)"
      end
    end

    context 'replacing code references' do
      before { @page = create(:page, creator: @creator, codes: [create(:code, identifier: 'test-123', creator: @creator)]) }

      it 'converts @references to code identifiers to full code paths (e.g. @code-test-123)' do
        @page.update_attribute :content, "[My code](@code-test-123)"
        expect(complete_internal_references(@page, :content)).to eq "[**My code**![](Code test thumbnail url)](https://codepen.io/test/pen/123){.code title=\"Code test title\"}"
      end

      it "doesn't take into account references that miss the @ (e.g. code-test-123)" do
        @page.update_attribute :content, "[](code-test-123)"
        expect(complete_internal_references(@page, :content)).to eq "[](code-test-123)"
      end

      it "fails gracefully if code identifier doesn't exist" do
        @page.update_attribute :content, "[Some alt](@code-inexistant)"
        expect(complete_internal_references(@page, :content)).to eq "[Some alt](@code-inexistant)"
      end

      it "only replaces identifiers of own codes" do
        other_page = create :page, creator: @creator, title: 'Other page', codes: [create(:code, creator: @creator, identifier: 'other-identifier')]

        @page.update_attribute :content, "[My code](@code-other-identifier)"
        expect(complete_internal_references(@page, :content)).to eq "[My code](@code-other-identifier)"
      end

      it 'replaces empty text with the code title' do
        @page.update_attribute :content, "[](@code-test-123)"
        expect(complete_internal_references(@page, :content)).to eq "[**Code test title**![](Code test thumbnail url)](https://codepen.io/test/pen/123){.code}"
      end

      context 'text different to code title' do
        it 'adds the code title as title attribute' do
          @page.update_attribute :content, "[some other title](@code-test-123)"
          expect(complete_internal_references(@page, :content)).to eq "[**some other title**![](Code test thumbnail url)](https://codepen.io/test/pen/123){.code title=\"Code test title\"}"
        end
      end

      context 'text equals code title' do
        it "doesn't add title as title attribute" do
          @page.update_attribute :content, "[Code test title](@code-test-123)"
          expect(complete_internal_references(@page, :content)).to eq "[**Code test title**![](Code test thumbnail url)](https://codepen.io/test/pen/123){.code}"
        end
      end
    end
  end
end