module Streaming
  module Admin
    module Stream
      class ImportLinksController < ImportController
        private

          def import_form
            ::Stream::ImportLinksForm
          end

          def import_service
            ::Stream::ImportLinks
          end

          def permitted_params
            params.require(:stream_event).permit(accesses_attributes: %i[
                                                   id
                                                   iframe_link
                                                   stream_user
                                                 ])
          end

          def accesses
            @event.accesses.select(&:new_record?)
          end
      end
    end
  end
end
