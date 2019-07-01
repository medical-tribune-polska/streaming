class RecountWatchedMinutesJob < ActiveJob::Base
  queue_as :stream

  def perform(event_id)
    event = ::Stream::Event.find(event_id)
    event.accesses.update_all(watched_minutes: {})

    Stream::CountWatchedTimeForUsers.new(event_id).call
  end
end
