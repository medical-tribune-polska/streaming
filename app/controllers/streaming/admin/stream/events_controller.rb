module Streaming
  module Admin
    module Stream
      class EventsController < BaseController
        before_action :set_stream_event, only: %i[edit update destroy show]
        before_action :set_new_stream_event, only: %i[new create]
        before_action :count_accesses, only: %i[new edit]

        def index
          @events = ::Stream::Event.order(id: :desc).page(params[:page])
        end

        def show
          stat = ::Stream::Statistics.new(@event.id).call(statistics_params)

          @data, @options = ::Stream::ChartJs.new(stat).generate_data
        end

        def new; end

        def create
          @event.assign_attributes(event_params)

          if @event.save
            flash[:notice] = I18n.t('stream_events.created')
            redirect_to action: :edit, id: @event.id
          else
            render :new
          end
        end

        def edit; end

        def update
          if @event.update(event_params)
            flash[:notice] = I18n.t('stream_events.updated')
            if event_params.key?(:accesses_attributes)
              redirect_to admin_stream_event_stream_accesses_path(@event)
            else
              redirect_to action: :index
            end
          else
            render :edit
          end
        end

        def destroy
          @event.destroy

          flash[:notice] = I18n.t('stream_events.destroyed')
          redirect_to action: :index
        end

        def export_accesses
          @event = ::Stream::Event.find(params[:event_id])

          respond_to do |format|
            format.csv do
              respond_with_csv
            end
            format.xlsx do
              p = Axlsx::Package.new
              wb = p.workbook
              wb.add_worksheet(name: 'Klienci') do |sheet|
                sheet.add_row ::Stream::Access::CSV_ATTRIBUTES
                collection_to_export.find_each do |access|
                  sheet.add_row ::Stream::Access::CSV_ATTRIBUTES.map { |attr| access.public_send(attr) }
                end
              end
              send_data p.to_stream.read, type: 'application/xlsx', filename: export_filename(ext: 'xlsx')
            end
          end
        end

        private

          def respond_with_csv
            send_data CsvGenerator.new(collection_to_export).perform!, filename: export_filename(ext: 'csv')
          end

          def collection_to_export
            @event.accesses.having_email.where(removed_at: nil, working_in_mt: false)
          end

          def export_filename(ext: 'csv')
            "streaming-magwet-#{normalized_event_name(@event)}-#{Time.now.to_i}.#{ext}"
          end

          def normalized_event_name(event)
            event.name.downcase.tr(' ', '-').unicode_normalize(:nfkd).encode('ASCII', replace: '')
          end

          def set_stream_event
            @event = ::Stream::Event.find(params[:id])
          end

          def set_new_stream_event
            @event = ::Stream::Event.new
          end

          def statistics_params
            start = params.dig(:statistics, :start)&.to_datetime || @event.starting || 1.day.ago
            hours = params.dig(:statistics, :hours)&.to_i || 5
            mt = params.dig(:statistics, :without_mt_users) || 'all'
            {}.tap do |o|
              o[:start] = start
              o[:finish] = start + hours.hours
              o[:without_mt_users] = mt.eql?('without_mt')
            end
          end

          def event_params
            params.require(:stream_event).permit(
              :name,
              :starting,
              :finishing,
              :place,
              :show_popup,
              :education_points,
              :agenda,
              :brochure,
              :congress_image,
              :congress_logo,
              :info_color,
              :popup_time,
              accesses_attributes: [
                :id,
                :paid_status,
                :checked,
                :action,
                :test_result
              ],
              breaks: [:starting, :finishing]
            )
          end
      end
    end
  end
end
