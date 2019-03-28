module Stream
  class AnalyticsController < BaseController
    before_action :event
    before_action :access

    def create
      analytic = Stream::Analytic.new(
        stream_event_id:  @event.id,
        stream_access_id: @access.id,
        watched_at:       Time.zone.now
      )
      if analytic.save
        render json: { status: :created }, status: :created
      else
        render json: analytic.errors, status: :unprocessable_entity
      end
    end

    private

      def event
        @event ||= ::Stream::Event.find(params[:event_id])
      end

      def access
        @access ||= @event.accesses.find(params[:access_id])
      end
  end
end
