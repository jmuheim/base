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
end
