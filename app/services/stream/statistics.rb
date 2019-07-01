module Stream
  class Statistics
    DATETIME_FORMAT = '%d.%m.%Y %R'.freeze

    def initialize(event_id)
      @event = Stream::Event.find(event_id)
    end

    def call(start: @event.starting - 1.hour, finish: @event.finishing, for_access_id: nil, without_mt_users: false)
      @for_access_id = for_access_id
      @without_mt_users = without_mt_users
      array_with_data = []
      raise 'Event start is empty' if start.nil?

      loop do
        start += 1.hour
        array_with_data << count_watcher_for_one_hour(start)
        break if start > finish
      end
      wrap_with_breaks(array_with_data.inject(&:merge)).inject(&:merge)
    end

    def collect_breaks_by_minutes
      @breaks ||= @event.breaks.map do |br|
        break_in_minute_iteration(br['starting'].in_time_zone, br['finishing'].in_time_zone)
      end.flatten.uniq
    end

    private

      def count_watcher_for_one_hour(start_datetime)
        labels = labels_for_one_hour_period(start_datetime)
        gather_statistics(start_datetime).reverse_merge(default_hash_of_zeros(start_datetime))
                                         .each_with_object({}).with_index { |((_k, v), o), i| o[labels[i]] = v }
      end

      def gather_statistics(start_datetime)
        Stream::Analytic.select('stream_access_id, watched_at')
                        .without_mt_users(@without_mt_users)
                        .for_access(@for_access_id)
                        .where(watched_at: start_datetime..(start_datetime + 1.hour))
                        .where(stream_event_id: @event.id)
                        .order(:watched_at)
                        .group_by { |a| a.watched_at.to_datetime.minute }
                        .map { |time, watchers| { time => count_unique_watchers_for_minute(watchers) } }
                        .inject(&:merge) || {}
      end

      def labels_for_one_hour_period(start_datetime)
        60.times.each_with_object([]) do |_t, o|
          start_datetime += 1.minute
          o << start_datetime.strftime(DATETIME_FORMAT)
        end
      end

      def count_unique_watchers_for_minute(collection_of_watchers)
        collection_of_watchers.each_with_object([]) do |watcher, object|
          object << watcher.stream_access_id unless object.include?(watcher.stream_access_id)
        end.count
      end

      def default_hash_of_zeros(start_datetime)
        start_minute = start_datetime.to_datetime.minute
        ([*start_minute..59] + [*0..start_minute]).product([0]).to_h
      end

      def break_in_minute_iteration(start, finish)
        h = []
        return h if start.nil? || finish.nil?

        while start <= finish
          h.push(start.to_datetime.strftime(DATETIME_FORMAT))
          start += 1.minute
        end
        h
      end

      def wrap_with_breaks(collection)
        collection.map do |time, watchers|
          {
            time => {
              count:    watchers,
              is_break: time.in?(collect_breaks_by_minutes)
            }
          }
        end
      end
  end
end
