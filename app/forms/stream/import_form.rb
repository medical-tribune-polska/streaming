module Stream
  class ImportForm
    attr_reader :accesses

    def initialize(accesses)
      @accesses = accesses
    end

    def process
      @accesses.each(&:save)
    end

    def check_accesses
      accesses.each_with_object({}).with_index do |(access, errors), i|
        errors[i] = check_access(access)
      end.compact
    end

    private

      def check_access(access)
        access.errors.try(:messages) unless access.valid?
      end
  end
end
