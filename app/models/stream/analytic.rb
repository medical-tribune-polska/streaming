class Stream::Analytic < Stream::Base
  belongs_to :event, class_name: 'Stream::Event', foreign_key: 'stream_event_id'
  belongs_to :access, class_name: 'Stream::Access', foreign_key: 'stream_access_id'

  scope :without_mt_users, -> (cond) { includes(:access).where(stream_accesses: {working_in_mt: false}) if cond }
  scope :for_access, -> (id = nil) { where(stream_access_id: id) if id }
end
