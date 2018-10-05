class UserPermission < ApplicationRecord
  belongs_to :user
  belongs_to :sector

  def self.active_boss
    where(level: 'BOSS').where(["start <= ? and end >= ?", Date.today, Date.today])
  end
end
