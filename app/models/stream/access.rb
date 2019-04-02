class Stream::Access < ActiveRecord::Base
  CSV_ATTRIBUTES = %w[
    first_name
    last_name
    email
    mobile_phone
    access_link
    human_paid_status
  ].freeze
  attr_accessor :checked

  enum paid_status: %i[not_paid paid proform participant]

  delegate :url_helpers, to: 'Rails.application.routes'

  scope :having_email, -> { where.not(email: nil) }
  scope :having_empty_email, -> { where(email: nil) }
  scope :imported_from_csv, -> { where(imported_from_csv: true) }

  belongs_to :event, class_name: 'Stream::Event', foreign_key: 'stream_event_id'
  has_many :analytics, class_name:  'Stream::Analytic',
                       foreign_key: 'stream_access_id',
                       dependent:   :destroy

  validates :iframe_link, :stream_user, uniqueness: true

  before_create :generate_random_slug

  def access_link
    return unless slug.present?

    url_helpers.stream_access_url(slug, host: Rails.application.config.app_domain)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def human_paid_status
    self.class.human_enum_name(:paid_status, paid_status)
  end

  def self.paid_status_attributes_for_select
    paid_statuses.map do |paid_status, _|
      [human_enum_name(:paid_status, paid_status), paid_status]
    end
  end

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def action=(action)
    if checked.eql?('1')
      self.paid_status = action
    end
  end

  def generate_random_slug
    loop do
      self.slug = SecureRandom.hex(3)
      break unless Stream::Access.where(slug: slug).exists?
    end
  end
end