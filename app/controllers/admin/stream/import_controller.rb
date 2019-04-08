module Admin
  module Stream
    class ImportController < ::Admin::Stream::BaseController
      before_action :event
      before_action :count_accesses

      def new; end

      def review
        file = params['file_input']
        unless File.extname(file.original_filename).eql?('.csv')
          flash[:danger] = 'Nieprawidłowy format pliku. Musi być <b>csv</b>.'
          redirect_to(:back) && return
        end

        create_object = import_service.new(file)
        review_callback(create_object)
        create_object.call(@event)

        @event = create_object.event
      rescue LoadError => e
        @error = e.message
        render :new
      end

      def create
        @event.attributes = permitted_params
        upload_form = import_form.new(accesses)

        @errors = upload_form.check_accesses
        if @errors.any?
          render action: :review
        else
          upload_form.process
          flash[:success] = 'Zaimportowano'
          redirect_to admin_stream_event_stream_accesses_path(@event)
        end
      end

      private

        def event
          @event ||= ::Stream::Event.find(params[:event_id])
        end

        def import_form
          raise 'Import form not provided'
        end

        def import_service
          raise 'Import service not provided'
        end

        def permitted_params
          raise 'Permitted params not implemented'
        end

        def review_callback(_); end

        def accesses
          @event.accesses
        end
    end
  end
end
