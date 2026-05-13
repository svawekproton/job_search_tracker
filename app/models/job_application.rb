class JobApplication < ApplicationRecord
  ALLOWED_URL_SCHEMES = %w[ http https ].freeze

  belongs_to :user
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

  validates :company_name, :position, :status, :applied_at, presence: true
  validate :url_has_http_scheme

  scope :search, ->(query) {
    if query.present?
      where("company_name LIKE ? OR position LIKE ? OR location LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
    end
  }

  private
    def url_has_http_scheme
      return if url.blank?

      uri = URI.parse(url)
      return if uri.host.present? && ALLOWED_URL_SCHEMES.include?(uri.scheme)

      errors.add(:url, "must be an HTTP or HTTPS URL")
    rescue URI::InvalidURIError
      errors.add(:url, "must be an HTTP or HTTPS URL")
    end
end
