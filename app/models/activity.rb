# frozen_string_literal: true

# Activity model
class Activity < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :description, :deadline
  validates_inclusion_of :public, in: [true, false]

  scope :visible, -> { where(public: true) }
end
