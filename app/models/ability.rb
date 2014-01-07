# See the CanCan wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(current_user)
    can :read, :all

    if current_user.present?
      can :update, User do |user|
        current_user == user
      end
    end
  end
end
