require 'rails_helper'

describe MarkdownHelper do
  describe '#markdown' do
    it 'converts a markdown formatted string to html' do
      expect(markdown('# Hello')).to have_css 'h1', text: 'Hello'
    end

    it "doesn't blow up with nil as param" do
      expect(markdown(nil)).to eq ''
    end

    it "converts php-markdown style tables" do
      expect(markdown("| th1 | th2 |\n| --- | --- |\n| td1 | td2 |")).to have_css 'table'
    end
  end

  describe '#indent_heading_level' do
    describe 'indentation' do
      subject do
        string = "# This is h1\n\n##This is h2\n\n # This is nothing\n\n #This too"
        markdown indent_heading_level(string, 2)
      end

      it 'indents heading levels (marked with dashes) by a certain amount' do
        should have_css 'h3', text: 'This is h1'
        should have_css 'h4', text: 'This is h2'
        should have_css 'p', text: '# This is nothing'
        should have_css 'p', text: '#This too'
      end
    end

    describe 'robustness' do
      it 'accepts nil' do
        expect(markdown indent_heading_level(nil, 2)).to eq ''
      end
    end
  end

  describe '#pandoc_version' do
    it 'returns the version' do
      expect(pandoc_version.to_i).to be > 0
    end
  end

  describe '#complete_internal_references' do
    context 'replacing page references' do
      before { @page = create :page, title: 'Cool title' }

      it 'converts @references to page ids to full page paths (e.g. @page-123)' do
        expect(complete_internal_references("[](@page-#{@page.id})")).to eq "[Cool title](/en/pages/#{@page.id})"
      end

      it "doesn't take into account references that miss the @ (e.g. page-123)" do
        expect(complete_internal_references("[](page-#{@page.id})")).to eq "[](page-#{@page.id})"
      end

      it "fails gracefully if page id doesn't exist" do
        expect(complete_internal_references("[Some alt](@page-123)")).to eq "[Some alt](@page-123)"
      end

      it 'replaces empty alt text with the page title' do
        expect(complete_internal_references("[](@page-#{@page.id})")).to eq "[Cool title](/en/pages/#{@page.id})"
      end

      context 'alt text different to page title' do
        it 'adds the page title as title attribute' do
          expect(complete_internal_references("[some other title](@page-#{@page.id})")).to eq "[some other title](/en/pages/#{@page.id}){title=\"Cool title\"}"
        end
      end

      context 'alt text equals page title' do
        it "doesn't add title as title attribute" do
          expect(complete_internal_references("[Cool title](@page-#{@page.id})")).to eq "[Cool title](/en/pages/#{@page.id})"
        end
      end
    end

    context 'replacing image references' do
      before { @page = create :page, :with_image }

      it 'converts @references to image identifiers to full image paths (e.g. @image-test-123)' do
        expect(complete_internal_references("Some text.\n\n![My image](@image-Image test identifier)\n\nSome more text.")).to eq "Some text.\n\n![My image](/uploads/image/file/#{@page.images.first.id}/image.jpg)\n\nSome more text."
      end

      it "doesn't take into account references that miss the @ (e.g. image-test-123)" do
        expect(complete_internal_references("[](image-Image test identifier")).to eq "[](image-Image test identifier"
      end

      it "fails gracefully if image identifier doesn't exist" do
        expect(complete_internal_references("[Some alt](@image-inexistant)")).to eq "[Some alt](@image-inexistant)"
      end
    end
  end
end
