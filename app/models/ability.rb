# See the CanCan wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(current_member)
    can :read, :all

    if current_member.present?
      can :update, Member do |member|
        current_member == member
      end
    end
  end
end
