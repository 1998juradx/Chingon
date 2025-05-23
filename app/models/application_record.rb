class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  ACTIVE = 0
  INACTIVE = 1
  SYSTEM = 2

  enum status: { active: ACTIVE, inactive: INACTIVE, system: SYSTEM }

  after_create :statusify

  def statusify
    if self.status.nil?
      self.status = ACTIVE
      self.save
    end
  end

  def self.actives
    where status: [nil, ACTIVE]
  end

  def self.inactives
    where status: INACTIVE
  end

  def self.system
    where status: INACTIVE
  end

  def is_active?
    [nil, ACTIVE].include? self.status
  end

  def is_inactive?
    self.status == INACTIVE
  end

end
