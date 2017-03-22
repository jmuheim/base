# See the CanCan wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities
#
# The ability is built upon the "everything disallowed first" principle:
# Nothing is allowed if not explicitly allowed somewhere.

class Ability
  include CanCan::Ability

  def initialize(current_user)
    alias_action :create, :read, :update, :destroy, to: :crud

    can :read, Page

    if current_user.nil?
      can :create, User
    else
      if current_user.has_role?(:admin)
        can :access, :rails_admin
        can :dashboard

        can :crud, :all # TODO: Remove this! Explicitly set every single ability!
      else
        can [:read, :update], User do |user|
          user == current_user
        end
      end

      cannot :destroy, User do |user|
        user == current_user
      end

      cannot :destroy, Page do |page|
        page.system?
      end
    end
  end
end
