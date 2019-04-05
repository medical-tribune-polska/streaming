class Stream::Analytic < Stream::Base
  belongs_to :event, class_name: 'Stream::Event', foreign_key: 'stream_event_id', touch: true
  belongs_to :access, class_name: 'Stream::Access', foreign_key: 'stream_access_id', touch: true

  scope :without_mt_users, -> (cond) { includes(:access).where(stream_accesses: {working_in_mt: false}) if cond }
  scope :for_access, -> (id = nil) { where(stream_access_id: id) if id }
  scope :online, -> { where('watched_at > ?', 1.minute.ago).distinct.count(:stream_access_id) }
end
