module Admin
  module Stream
    class BaseController < ::BaseController
      private

        def count_accesses
          @event_accesses = @event.accesses.having_email.count
          @event_free_accesses = @event.accesses.having_empty_email.count
        end
    end
  end
end
