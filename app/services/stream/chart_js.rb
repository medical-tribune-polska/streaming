module Stream
  class ChartJs
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def generate_data
      [data, options]
    end

    private

      def data
        {
          labels:   @collection.keys,
          datasets: [
            {
              label:            'Streaming',
              background_color: color_green,
              border_color:     'rgba(220,220,220,1)',
              data:             @collection.map { |_datetime, v| v[:is_break] ? 0 : v[:count] }
            },
            {
              label:            'Przerwa',
              background_color: color_red,
              border_color:     'rgba(151,187,205,1)',
              data:             @collection.map { |_datetime, v| v[:is_break] ? v[:count] : 0 }
            }
          ]
        }
      end

      def options
        {
          responsive:          true,
          maintainAspectRatio: false,
          aspectRatio:         true,
          title:               {
            display: false
          },
          tooltips:            {
            mode:      'index',
            intersect: false
          },
          hover:               {
            mode:      'nearest',
            intersect: true
          },
          legend:              {
            display: false
          },
          scales:              {
            xAxes: [
              {
                display:    true,
                scaleLabel: {
                  display: true
                }
              }
            ],
            yAxes: [
              {
                display:    true,
                scaleLabel: {
                  display: true
                }
              }
            ]
          }
        }
      end

      def color_red
        'rgb(255, 99, 132)'
      end

      def color_green
        'rgb(75, 192, 192)'
      end
  end
end
