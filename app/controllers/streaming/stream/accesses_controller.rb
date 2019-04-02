module Streaming
  module Stream
    class AccessesController < MainPageController
      layout 'new_design'
      helper_method :magazine_code

      def show
        @stream_access = Stream::Access.find_by!(slug: params[:slug])
        not_found if @stream_access.removed_at.present?
        @stream_event = @stream_access.event
      end

      def magazine_code
        'mw'
      end
    end
  end
end
