class Note < ApplicationRecord
  CATEGORIES = [ "Question", "Answer", "General" ].freeze
  INTERVIEW_PREP_CATEGORIES = [ "Question", "Answer" ].freeze

  belongs_to :job_application
  has_rich_text :content

  validates :content, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  scope :interview_prep, -> { where(category: INTERVIEW_PREP_CATEGORIES) }

  def self.category_options
    CATEGORIES.map { |category| [ category, category ] }
  end

  def interview_prep_category?
    INTERVIEW_PREP_CATEGORIES.include?(category)
  end
end
