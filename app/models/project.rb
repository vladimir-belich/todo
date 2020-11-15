class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order :priority }, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
end
