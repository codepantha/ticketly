class Tag < ApplicationRecord
  has_and_belongs_to_many :tickets

  scope :search_tag, ->(search_term) { where('name LIKE ?', search_term).first }
end
