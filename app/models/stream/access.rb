class Stream::Access < Stream::Base
  CSV_ATTRIBUTES = %w[
    first_name
    last_name
    email
    mobile_phone
    access_link
    human_paid_status
    kwalifukuje_sie_to_testu
    all_watched_minutes
    test_result
  ].freeze
  attr_accessor :checked

  enum paid_status: %i[not_paid paid proform participant]

  delegate :url_helpers, to: 'Rails.application.routes'

  scope :having_email, -> { where.not(email: nil) }
  scope :having_empty_email, -> { where(email: nil) }
  scope :imported_from_csv, -> { where(imported_from_csv: true) }
  scope :not_removed, -> { where(removed_at: nil) }
  scope :removed, -> { where.not(removed_at: nil) }
  scope :not_mt, -> { where(working_in_mt: false) }

  belongs_to :event, class_name: 'Stream::Event', foreign_key: 'stream_event_id', touch: true
  has_many :analytics, class_name:  'Stream::Analytic',
                       foreign_key: 'stream_access_id',
                       dependent:   :destroy

  validates :iframe_link, :stream_user, uniqueness: true

  before_create :generate_random_slug

  store_accessor :watched_minutes, :all_watched_minutes, :first_day_watched_minutes, :second_day_watched_minutes

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
    self.paid_status = action if checked.eql?('1')
  end

  def generate_random_slug
    loop do
      self.slug = SecureRandom.hex(3)
      break unless Stream::Access.where(slug: slug).exists?
    end
  end

  def kwalifukuje_sie_to_testu
    if all_watched_minutes.present?
      all_watched_minutes >= minimum_watched_minutes_to_process_test ? 'Tak' : 'Nie'
    end
  end

  private

    def minimum_watched_minutes_to_process_test
      event_duration_in_days.eql?(1) ? 120 : 240
    end

    def event_duration_in_days
      if event.finishing && event.starting
        (event.finishing.to_datetime - event.starting.to_datetime).to_i
      else
        1
      end
    end
end
