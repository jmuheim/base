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
      define_abilities_for_guests  current_user, request_format
    else # User (logged in)
      define_abilities_for_editors current_user, request_format if current_user.has_role? :editor
      define_abilities_for_admins  current_user, request_format if current_user.has_role? :admin
    end

    define_general_abilities current_user, request_format
  end

  def define_aliases!
    clear_aliased_actions # We want to differentiate between #show and #index actions!

    alias_action :new,  to: :create
    alias_action :edit, to: :update

    alias_action :index, :create, :read, :update, :destroy, to: :crud
  end

  def define_general_abilities(current_user, request_format)
    can :read, Page
    can :index, Page if request_format == :atom

    can [:read, :update], User do |user|
      user == current_user
    end

    cannot :destroy, User do |user|
      user == current_user
    end

    cannot :destroy, Page do |page|
      page.system?
    end
  end

  def define_abilities_for_guests(current_user, request_format)
    can :create, User
  end

  def define_abilities_for_editors(current_user, request_format)
    can :index, Page
    can :create, Page
    can :update, Page

    can :destroy, Page do |page|
      page.creator == current_user
    end
  end

  def define_abilities_for_admins(current_user, request_format)
    can :access, :rails_admin
    can :crud, :all
  end
end
