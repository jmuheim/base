# See the CanCan wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities
#
# The ability is built upon the "everything disallowed first" principle:
# Nothing is allowed if not explicitly allowed somewhere.

class Ability
  include CanCan::Ability

  def initialize(current_user)
    define_aliases!

    if current_user.nil? # Guest (not logged in)
      define_abilities_for_guests current_user
    else
      case current_user.role.to_sym
      when :user
        define_abilities_for_users current_user
      when :editor
        define_abilities_for_editors current_user
      when :admin
        define_abilities_for_admins current_user
      else
        raise "Unknown user role #{current_user.role}!"
      end
    end
  end

  def define_aliases!
    clear_aliased_actions # We want to differentiate between #read and #index actions!

    alias_action :show, to: :read
    alias_action :new,  to: :create
    alias_action :edit, to: :update

    alias_action :index, :create, :read, :update, :destroy, to: :crudi
  end

  def define_abilities_for_guests(current_user)
    can :read,  Page

    can :create, User
  end

  def define_abilities_for_users(current_user)
    can :read, Page

    can [:index, :read], User
    can(:update, User) { |user| user == current_user }
  end

  def define_abilities_for_editors(current_user)
    can [:index, :read], Code
    can [:index, :read], Image

    can :crudi, Page

    can [:index, :read], User
    can([:update, :destroy], User) { |user| user == current_user }

    can [:index, :read], PaperTrail::Version
  end

  def define_abilities_for_admins(current_user)
    can [:read, :edit, :update], AppConfig

    can :edit_role, User do |user|
      user != current_user
    end

    can :edit_disabled, User do |user|
      user != current_user
    end

    can [:index, :read], Code
    can [:index, :read], Image

    can :crudi, Page

    can [:index, :create, :read, :update], User
    can(:destroy, User) { |user| user != current_user }

    can [:index, :read], PaperTrail::Version
  end
end
