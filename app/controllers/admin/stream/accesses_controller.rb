module Admin
  module Stream
    class AccessesController < ::Admin::Stream::BaseController
      before_action :event
      before_action :access, only: %w[edit update destroy switch_removed]
      before_action :new_access, only: %i[new create]
      before_action :count_accesses

      def index
        @q = @event.accesses.includes(:event).having_email.order(removed_at: :desc, id: :desc).ransack(params[:q])

        @accesses = @q.result
      end

      def edit
        if @event.starting.present?
          stat = ::Stream::Statistics.new(@event.id).call(statistics_params)

          @data, @options = ::Stream::ChartJs.new(stat).generate_data
        end
      end

      def update
        if @access.update(access_params)
          flash[:notice] = I18n.t('stream_events.updated')
          redirect_to action: :index
        else
          render :edit
        end
      end

      def new
        render(:no_free_links) && return if @access.nil?
      end

      def destroy
        new_attributes = ::Stream::Access.new.attributes.except 'id',
                                                                'stream_event_id',
                                                                'iframe_link',
                                                                'stream_user',
                                                                'created_at',
                                                                'updated_at'
        @access.assign_attributes @access.attributes.merge(new_attributes)
        @access.generate_random_slug
        @access.save

        flash[:notice] = 'Użytkownik został usunięty'
        redirect_to action: :index
      end

      def switch_removed
        @access.removed_at ? @access.update(removed_at: nil) : @access.touch(:removed_at)
        redirect_to admin_stream_event_stream_accesses_path(@event)
      end

      def recount_watched_minutes
        ::RecountWatchedMinutesJob.perform_later(params[:event_id])
        flash[:notice] = 'Statystyki dla użytkowników będą przeliczone w ciągu 5 minut'
        redirect_to(:back) && return
      end

      private

        def event
          @event ||= ::Stream::Event.find(params[:event_id])
        end

        def access
          @access ||= @event.accesses.find(params[:id])
        end

        def new_access
          @access = @event.accesses.having_empty_email.first
        end

        def access_params
          params.require(:stream_access).permit %i[
            id
            first_name
            last_name
            email
            mobile_phone
            iframe_link
            stream_user
            city
            voivodeship
            paid
            perdix_id
            watched_minutes
            paid_status
            test_result
            working_in_mt
            imported_from_csv
          ] + [notes: []]
        end

        def statistics_params
          start_datetime = params.dig(:statistics, :start)&.to_datetime
          warsaw_offset = Time.now.in_time_zone('Warsaw').utc_offset.seconds
          normalize_start = start_datetime - warsaw_offset - 1.hour if start_datetime

          start = normalize_start || (@event.starting - 1.hour).utc || 1.day.ago
          hours = params.dig(:statistics, :hours)&.to_i || 5
          {}.tap do |o|
            o[:start] = start
            o[:finish] = start + hours.hours
            o[:for_access_id] = @access.id
          end
        end
    end
  end
end
