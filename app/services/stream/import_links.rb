module Stream
  class ImportLinks
    require 'csv'

    attr_reader :event

    def initialize(file)
      data = open(file)
      @data = CSV.parse(data, headers: false, col_sep: ';')
    end

    def call(event)
      @event = event
      @data.each(&method(:process))
      @accesses = event.accesses
    end

    private

      def process(row)
        event.accesses.build(
          stream_user: row[0],
          iframe_link: row[1]
        )
      end
  end
end
