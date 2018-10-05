class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Issue
    can :destroy, Issue do |issue|
      permissions = user.user_permissions.active_boss.map { |x| x.sector_id }
      permissions.include? issue.sector.id
    end
  end
end
