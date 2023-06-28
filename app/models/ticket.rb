# frozen_string_literal: true

class Ticket < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  belongs_to :project
  belongs_to :author, class_name: 'User'
  has_one_attached :attachment
  has_many :comments, dependent: :destroy
  belongs_to :state, optional: true
end
