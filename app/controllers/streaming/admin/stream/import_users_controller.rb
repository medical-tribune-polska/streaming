module Streaming
  module Admin
    module Stream
      class ImportUsersController < ImportController
        before_action :load_existing_user_ids, only: %i[create review]

        private

          def import_form
            ::Stream::ImportUsersForm
          end

          def import_service
            ::Stream::ImportUsers
          end

          def permitted_params
            params.require(:stream_event).permit(accesses_attributes: %i[
                                                   id
                                                   perdix_id
                                                   city
                                                   voivodeship
                                                   paid_status
                                                   test_result
                                                   first_name
                                                   last_name
                                                   email
                                                   mobile_phone
                                                   imported_from_csv
                                                   removed_at
                                                 ])
          end

          def load_existing_user_ids
            @existing_users ||= event.accesses.having_email.ids
          end

          def review_callback(create_object)
            create_object.check_whether_enough_links(@event)
          end
      end
    end
  end
end
