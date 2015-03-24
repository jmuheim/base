require 'rails_helper'

describe PageTitleAndHeadlineHelper do
  describe '#headline_with_flash' do
    # See http://stackoverflow.com/questions/29229368/rspec-rails-stub-virtual-path-for-translation-helper-to-test-an-application
    # describe '#headline_with_flash' do
    #   before { helper.instance_variable_set(:@virtual_path, 'pages.show.root') }
    #   subject { headline_with_flash }
    #
    #   it { should eq 'Welcome to Base!' }
    # end

    describe '#headline_with_flash("Some title")' do
      subject { headline_with_flash('Some title') }

      it { should eq '<div class="headline"><h1>Some title</h1></div>' }
    end

    # See http://stackoverflow.com/questions/29229368/rspec-rails-stub-virtual-path-for-translation-helper-to-test-an-application
    # describe '#headline_with_flash(user: "John")' do
    #   before { helper.instance_variable_set(:@virtual_path, 'users.show') }
    #   subject { headline_with_flash }
    #
    #   it { should eq 'User John' }
    # end

    describe '#headline_with_flash("New title", user: "John")' do
      it 'raises an error when both a title and options are given' do
        expect { headline_with_flash('New title', user: "John") }.to raise_error
      end
    end
  end

  describe '#headline_with_flash' do
    it 'raises an error when headline_with_flash was not called before' do
      expect { headline_with_flash }.to raise_error
    end

    # See http://stackoverflow.com/questions/29229368/rspec-rails-stub-virtual-path-for-translation-helper-to-test-an-application
    # context 'without a flash' do
    #   before { helper.instance_variable_set(:@virtual_path, 'pages.show.root') }
    #   subject do
    #     headline_with_flash
    #     headline_with_flash
    #   end
    #
    #   it { should eq 'Welcome to Base!' }
    # end

    # See http://stackoverflow.com/questions/29229368/rspec-rails-stub-virtual-path-for-translation-helper-to-test-an-application
    # context 'with a flash' do
    #   before { controller.flash[:alert] = 'This is an alert!' }
    #   subject do
    #     headline_with_flash
    #     headline_with_flash
    #   end
    #
    #   it { should eq 'Alert: This is an alert! Welcome to Base!' }
    # end
  end

  # TODO: spec for #headline, #title_tag and #default_headline!
end
