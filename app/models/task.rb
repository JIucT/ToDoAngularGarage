class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: 4..255, uniqueness: { scope: :project_id }
  validates :priority, presence: true
  validates :project_id, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.priority ||= Task.where(project_id: self.project_id).count
    self.completed ||= false
  end    

  def self.recount_priorities(project_id, old_priority, new_priority)
    tasks = Task.includes(:comments).where(project_id: project_id)
    tasks.find_each do |task_item|
      if task_item.priority.between?(old_priority+1, new_priority)
        task_item.update( priority: task_item.priority.pred)
      elsif task_item.priority.between?(new_priority, old_priority)
        task_item.update( priority: task_item.priority.next)  
      end
    end
    return tasks
  end
end
