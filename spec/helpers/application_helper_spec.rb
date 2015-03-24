require 'rails_helper'

describe ApplicationHelper do
  describe '#icon' do
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

  describe '#container_for' do
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

  describe '#page_heading' do
    # See http://stackoverflow.com/questions/29229368/rspec-rails-stub-virtual-path-for-translation-helper-to-test-an-application
    # describe '#page_heading' do
    #   before { helper.instance_variable_set(:@virtual_path, 'pages.show.root') }
    #   subject { page_heading }
    #
    #   it { should eq 'Welcome to Base!' }
    # end

    describe '#page_heading("Some title")' do
      subject { page_heading('Some title') }

      it { should eq 'Some title' }
    end

    # See http://stackoverflow.com/questions/29229368/rspec-rails-stub-virtual-path-for-translation-helper-to-test-an-application
    # describe '#page_heading(user: "John")' do
    #   before { helper.instance_variable_set(:@virtual_path, 'users.show') }
    #   subject { page_heading }
    #
    #   it { should eq 'User John' }
    # end

    describe '#page_heading("New title", user: "John")' do
      it 'raises an error when both a title and options are given' do
        expect { page_heading('New title', user: "John") }.to raise_error
      end
    end
  end

  describe '#page_title' do
    it 'raises an error when page_heading was not called before' do
      expect { page_title }.to raise_error
    end

    # See http://stackoverflow.com/questions/29229368/rspec-rails-stub-virtual-path-for-translation-helper-to-test-an-application
    # context 'without a flash' do
    #   before { helper.instance_variable_set(:@virtual_path, 'pages.show.root') }
    #   subject do
    #     page_heading
    #     page_title
    #   end
    #
    #   it { should eq 'Welcome to Base!' }
    # end

    # See http://stackoverflow.com/questions/29229368/rspec-rails-stub-virtual-path-for-translation-helper-to-test-an-application
    # context 'with a flash' do
    #   before { controller.flash[:alert] = 'This is an alert!' }
    #   subject do
    #     page_heading
    #     page_title
    #   end
    #
    #   it { should eq 'Alert: This is an alert! Welcome to Base!' }
    # end
  end
end
