class Comment < ActiveRecord::Base
  belongs_to :task
  belongs_to :project
  has_attached_file :file, styles: { small: "100x100#", medium: "300x300>", thumb: "70x70#" }

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/  
  validate :text, presence: true, length: 4..255, uniqueness: { scope: :tassk_id }
end
