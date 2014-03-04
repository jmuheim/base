# See the CanCan wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(current_user)
    can :read, User

    unless current_user.guest?
      # Update himself
      can :update, User do |user|
        current_user == user
      end

      if current_user.has_role?(:admin)
        can :manage, User
      end

      cannot :destroy, User do |user|
        user == current_user
      end
    end
  end
end
