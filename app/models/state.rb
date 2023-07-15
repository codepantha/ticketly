class State < ApplicationRecord
  has_many :tickets

  def to_s
    name
  end

  def self.default
    find_by(default: true)
  end

  def make_default!
    State.update_all(default: false)
    update!(default: true)
  end

  scope :search_state, ->(search_term) { where('name LIKE ?', "%#{search_term}%").first }
end
