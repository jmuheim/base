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
      it 'indents heading levels (marked with dashes) by a certain amount' do
        string = "# This is h1\n\n## This is h2\n\n # This is nothing\n\n #This too"
        result = markdown indent_heading_level(string, 2)

        expect(result).to eq "<h3 id=\"this-is-h1\">This is h1</h3>\n<h4 id=\"this-is-h2\">This is h2</h4>\n<p># This is nothing</p>\n<p>#This too</p>"
      end
    end

    describe 'visual heading level indentation' do
      it 'adds a class "h#" for a provided visual heading level' do
        string = "# This is h1\n\n## This is h2\n\nSome text"
        result = markdown indent_heading_level(string, 2, 1)

        expect(result).to eq "<h3 class=\"h1\" id=\"this-is-h1\">This is h1</h3>\n<h4 class=\"h2\" id=\"this-is-h2\">This is h2</h4>\n<p>Some text</p>"
      end
    end

    describe 'exceeding heading level limit of 6' do
      it 'adds a role="heading" and aria-level="X"' do
        string = "# This is h1\n\n## This is h2\n\n### This is h3\n\nSome text"
        result = markdown indent_heading_level(string, 5)

        expect(result).to eq "<h6 id=\"this-is-h1\">This is h1</h6>\n<p class=\"heading\" role=\"heading\" aria-level=\"7\" id=\"this-is-h2\">This is h2</p>\n<p class=\"heading\" role=\"heading\" aria-level=\"8\" id=\"this-is-h3\">This is h3</p>\n<p>Some text</p>"
      end
    end

    describe 'robustness' do
      it 'accepts nil' do
        expect(markdown indent_heading_level(nil, 2)).to eq ''
      end
    end
  end
end
