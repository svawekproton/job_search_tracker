class Note < ApplicationRecord
  belongs_to :job_application
  has_rich_text :content

  validates :content, presence: true
end
