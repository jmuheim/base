# See the CanCan wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(current_user)
    can :read, User

    # Update himself
    can :update, User do |user|
      current_user == user
    end

    unless current_user.guest?
      if current_user.has_role?(:admin)
        can :manage, User
      end
    end
  end
end
