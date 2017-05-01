require 'rails_helper'

describe VersionsHelper do
  describe '#versions_whodunnit' do
    it 'returns a link to an existing user' do
      user = create :user
      expect(versions_whodunnit(user.id)).to eq '<a href="/en/users/1">User test name</a>'
    end

    it "returns the passed id if user doesn't exist" do
      expect(versions_whodunnit(123)).to eq 123
    end
  end
end
