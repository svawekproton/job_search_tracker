class JobApplication < ApplicationRecord
  has_one_attached :cv
  has_one_attached :cover_letter
  has_many :notes, dependent: :destroy
  has_many :events, dependent: :destroy

  enum :status, {
    applied: 0,
    interviewing: 1,
    offered: 2,
    rejected: 3,
    withdrawn: 4
  }, default: :applied

  validates :company_name, :position, :status, presence: true
end
