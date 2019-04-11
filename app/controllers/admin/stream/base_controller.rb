module Admin
  module Stream
    class BaseController < ::BaseController
      protected

        def params_cache_key(params)
          params.transform_keys(&:to_s)
                .transform_values { |v| v.is_a?(Array) ? v.sort : v }
                .sort_by { |k, _| k }.each_with_object('') do |(k, v), cache_key|
            cache_key << "#{k}:#{v}"
          end
        end

      private

        def count_accesses
          @event_accesses = @event.accesses.having_email.not_removed.count
          @paid_event_accesses = @event.accesses.having_email.paid.not_removed.not_mt.count
          @not_paid_event_accesses = @event.accesses.having_email.not_paid.not_removed.not_mt.count
          @mt_event_accesses = @event.accesses.having_email.where(working_in_mt: true).not_removed.count
          @suspended_accesses = @event.accesses.having_email.removed.count
          @event_free_accesses = @event.accesses.having_empty_email.count
        end
    end
  end
end
