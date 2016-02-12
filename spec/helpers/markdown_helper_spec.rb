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
end
