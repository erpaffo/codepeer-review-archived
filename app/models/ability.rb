# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :update, User, id: user.id
      can :manage, Snippet, user_id: user.id
    end
  end
end
