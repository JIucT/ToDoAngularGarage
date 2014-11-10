class Comment < ActiveRecord::Base
  belongs_to :task
  belongs_to :project
  has_attached_file :file, styles: { small: "100x100#", medium: "300x300>", thumb: "32x32#" }

  validates :text, presence: true, length: 4..255, uniqueness: { scope: :task_id }
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/  
  validates_attachment :file, size: { in: 0..10.megabytes }
  

  def file_full_url
    file.url(:original)
  end

  def file_thumb_url
    file.url(:thumb)
  end
end
