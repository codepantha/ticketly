class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :active, -> { where(archived_at: nil) }

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end

  def archive!
    self.update(archived_at: Time.now)
  end

  # Archived users are not permitted to login
  # Let's overwrite the active_for_authentication? devise method to ensure this
  def active_for_authentication?
    super && archived_at.nil?
  end

  # Let's overwrite the inactive_message devise method if user is archived
  # to ensure that the correct message why a user can't log in is displayed
  def inactive_message
    archived_at.nil? ? super : :archived
  end


end
