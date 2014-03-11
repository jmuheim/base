# See the CanCan wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(current_user)
    alias_action :create, :read, :update, :destroy, to: :crud

    can :read, User

    if current_user.guest?
      can :create, User
    else
      can :update, User do |user|
        user == current_user # Update himself
      end

      if current_user.has_role?(:admin)
        can :crud, User
      end

      cannot :destroy, User do |user|
        user == current_user
      end
    end
  end
end