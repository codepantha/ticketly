# frozen_string_literal: true

class Ticket < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  belongs_to :project
end
