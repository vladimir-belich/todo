class Task < ApplicationRecord
  belongs_to :project

  validates :name, presence: true
  validates :name, uniqueness: { scope: :project_id }

  def increase_priority(task)
    task.priority -= 1 if task.priority > 0
  end

  def lower_priority(task)
    task.priority += 1
  end
end
