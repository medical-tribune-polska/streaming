class Stream::Event < ActiveRecord::Base
  store_accessor :settings, :education_points, :place, :info_color, :show_popup, :popup_time
  has_many :accesses, class_name:  'Stream::Access',
                      foreign_key: 'stream_event_id',
                      dependent:   :destroy

  has_many :analytics, class_name:  'Stream::Analytic',
                       foreign_key: 'stream_event_id',
                       dependent:   :destroy

  accepts_nested_attributes_for :accesses

  has_attached_file :congress_image
  validates_attachment_content_type(
    :congress_image,
    content_type: %r{\Aimage\/.*\z}
  )

  has_attached_file :congress_logo
  validates_attachment_content_type(
    :congress_logo,
    content_type: %r{\Aimage\/.*\z}
  )

  has_attached_file :brochure
  validates_attachment_content_type :brochure, content_type: 'application/pdf'

  validates :name, presence: true
  validates :popup_time, numericality: { only_integer: true, inclusion: 3..999 }
end
