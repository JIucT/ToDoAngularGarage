class Task < ActiveRecord::Base
  belongs_to :project

  validates :title, presence: true, length: 4..255
  validates :priority, presence: true
  validates :project_id, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.priority ||= 0
    self.completed ||= false
  end    
end
