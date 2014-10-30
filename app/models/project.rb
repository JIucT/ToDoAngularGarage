class Project < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, length: 4..255

  after_initialize :set_defaults

  def set_defaults
    if self.title.nil? || self.title.empty?
      self.title = "Enter project name"
    end
  end  
end
