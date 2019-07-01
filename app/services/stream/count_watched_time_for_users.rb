module Stream
  class CountWatchedTimeForUsers
    def initialize(event_id)
      @event = ::Stream::Event.find(event_id)
    end

    def call
      count_minutes = lambda do |access_id|
        Stream::Statistics.new(@event.id)
                          .call(for_access_id: access_id)
                          .each_with_object(all_watched_minutes: 0, first_day_watched_minutes: 0, second_day_watched_minutes: 0) do |(t, h), o|
                            if h[:is_break].eql?(false)
                              first_date ||= t.to_datetime.strftime('%F')
                              current_statistics_date = t.to_datetime.strftime('%F')
                              is_first_day = first_date == current_statistics_date
                              if is_first_day
                                o[:first_day_watched_minutes] += h[:count]
                              else
                                o[:second_day_watched_minutes] += h[:count]
                              end
                              o[:all_watched_minutes] += h[:count]
                            end
                          end
      end

      @event.accesses.having_email.find_each do |access|
        access.update(watched_minutes: count_minutes.call(access.id))
      end
    end
  end
end
