class Activity < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :description, :public, :deadline
end
