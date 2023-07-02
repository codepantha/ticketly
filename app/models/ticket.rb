# frozen_string_literal: true

class Ticket < ApplicationRecord
  before_save :assign_default_state

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  belongs_to :project
  belongs_to :author, class_name: 'User'
  has_one_attached :attachment
  has_many :comments, dependent: :destroy
  belongs_to :state, optional: true
  has_and_belongs_to_many :watchers,
                          join_table: 'ticket_watchers',
                          class_name: 'User'

  has_and_belongs_to_many :tags

  private

  def assign_default_state
    self.state ||= State.default
  end
end
