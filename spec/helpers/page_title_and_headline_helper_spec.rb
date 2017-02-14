require 'rails_helper'

describe PageTitleAndHeadlineHelper do
  describe '#headline_with_flash' do
    describe 'no params given' do
      before { helper.instance_variable_set(:@virtual_path, 'homepage.show') }
      subject { helper.headline_with_flash } # Why do we need explicit receiver? See http://stackoverflow.com/questions/29229368

      it { should have_content 'Welcome to Base!' }
    end

    describe '#headline_with_flash("Some title")' do
      subject { headline_with_flash('Some title') }

      it { should have_content 'Some title' }
    end

    describe '#headline_with_flash(user: John)' do
      before { helper.instance_variable_set(:@virtual_path, 'devise.registrations.show') }
      subject { helper.headline_with_flash(user: 'John') }

      it { should have_content 'Welcome, John!' }
    end

    context 'with a flash' do
      before do
        controller.flash[:alert]  = 'This is an alert!'
        controller.flash[:notice] = 'This is a notice!'
      end

      subject { helper.headline_with_flash('Some title') }

      it { should have_content 'Some title' }
      it { should have_content 'Alert: This is an alert!' }
      it { should have_content 'Notice: This is a notice!' }
    end
  end

  describe '#flash_messages' do
    before { allow(helper).to receive(:icon).and_return 'Close' }
    subject do
      helper.flash_messages alert: 'This is an alert!',
                            notice: 'This is a notice!'
    end

    it { should have_content 'Alert: This is an alert!' }
    it { should have_content 'Notice: This is a notice!' }
  end

  describe '#title_tag' do
    it 'raises an error when both a title and options are given' do
      expect { expect(title_tag).to raise_error 'No page heading provided! Be sure to call #headline_with_flash first.' }
    end

    context 'on root path' do
      subject do
        allow(helper).to receive(:current_page?).and_return true
        helper.headline_with_flash('This is the title')
        helper.title_tag
      end

      it { should eq '<title>This is the title</title>' }
    end

    context 'on other path' do
      subject do
        helper.headline_with_flash('This is the title')
        helper.title_tag
      end

      it { should eq '<title>This is the title - Base</title>' }
    end

    context 'with flash' do
      subject do
        controller.flash[:alert]  = 'This is an alert!'
        controller.flash[:notice] = 'This is a notice!'
        helper.headline_with_flash('This is the title')
        helper.title_tag
      end

      it { should eq '<title>Alert: This is an alert! Notice: This is a notice! This is the title - Base</title>' }
    end

    context 'with prefixes' do
      subject do
        helper.headline_with_flash('This is the title')
        helper.title_prefix('This is a first prefix')
        helper.title_prefix('This is another prefix')
        helper.title_tag
      end

      it { should eq '<title>This is another prefix - This is a first prefix - This is the title - Base</title>' }
    end
  end
end
