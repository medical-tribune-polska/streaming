module Stream
  class CountWatchedTimeForUsers
    def initialize(event_id)
      @event = ::Stream::Event.find(event_id)
    end

    def call
      count_minutes = lambda do |access_id|
        Stream::Statistics.new(@event.id)
                          .call(for_access_id: access_id)
                          .each_with_object(sum: 0) do |(_t, h), o|
                            o[:sum] += h[:count] if h[:is_break].eql?(false)
                          end[:sum]
      end

      @event.accesses.having_email.find_each do |access|
        access.update(watched_minutes: count_minutes.call(access.id))
      end
    end
  end
end
