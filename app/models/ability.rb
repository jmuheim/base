# See the CanCan wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities
#
# The ability is built upon the "everything disallowed first" principle:
# Nothing is allowed if not explicitly allowed somewhere.

class Ability
  include CanCan::Ability

  def initialize(current_user, request_format = nil)
    define_aliases!

    if current_user.nil? # Guest (not logged in)
      define_abilities_for_guests current_user, request_format
    else
      case current_user.role.to_sym
      when :user
        define_abilities_for_users current_user, request_format
      when :editor
        define_abilities_for_editors current_user, request_format
      when :admin
        define_abilities_for_admins current_user, request_format
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

    alias_action :index, :create, :read, :update, :destroy, to: :crud
  end

  def define_abilities_for_guests(current_user, request_format)
    can :index, Page if request_format == :atom
    can :read,  Page

    can :create, User
  end

  def define_abilities_for_users(current_user, request_format)
    can :index, Page if request_format == :atom
    can :read, Page

    can [:index, :read], User
    can(:update, User) { |user| user == current_user }
  end

  def define_abilities_for_editors(current_user, request_format)
    can :crud, Page

    can [:index, :read], User
    can(:update, User) { |user| user == current_user }
  end

  def define_abilities_for_admins(current_user, request_format)
    can :access, :rails_admin

    can :crud, Page

    can [:index, :create, :read, :update], User
    can(:destroy, User) { |user| user != current_user }
  end
end
