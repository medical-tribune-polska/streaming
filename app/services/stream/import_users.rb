module Stream
  class ImportUsers
    require 'csv'

    attr_reader :event

    def initialize(file)
      data = open(file)
      @data = CSV.parse(data, headers: true, col_sep: ';', encoding: 'utf-8', header_converters: :symbol)
    end

    def call(event)
      @event = event
      @event.accesses.reload
      @existing_accesses_ids = @event.accesses.ids
      @data.each(&method(:process))
      event.accesses
           .having_email
           .imported_from_csv
           .where(id: (@existing_accesses_ids - (@used_users_ids || [])))
           .each(&method(:remove))
      @accesses = event.accesses
    end

    def check_whether_enough_links(event)
      @event = event
      available_links = event.accesses.having_empty_email.count
      users_to_create = @data.count - ids_of_existing_users.count
      if available_links < users_to_create
        raise LoadError, "Za mało dostępnych linków. Linków: #{available_links}. Użytkowników do dodania: #{users_to_create}"
      end
    end

    private

      def process(row)
        access = find_access(row)

        if access.email.blank?
          # prevent assigning users to same empty links
          (@used_links_ids ||= []) << access.id
        else
          # user found by email. to set removed_at if user not found in csv
          (@used_users_ids ||= []) << access.id
        end

        @event.accesses.build(
          first_name:        split_names(row).first,
          last_name:         split_names(row).last,
          email:             row[:e_mail____1] || fill_blank_email(row),
          mobile_phone:      row[:telefon_ko1] || row[:telefon_ko2],
          city:              cap(row[:miasto]),
          voivodeship:       cap(row[:wojewodztwo]),
          perdix_id:         row[:id_klienta],
          id:                access.id,
          imported_from_csv: true,
          removed_at:        nil
        )
      end

      def find_access(row)
        event.accesses.where('email = ? OR perdix_id = ?', row[:e_mail____1], row[:id_klienta]).first ||
          event.accesses.having_empty_email.where.not(id: @used_links_ids).first!
      end

      def split_names(row)
        nazwa = cap(row[:nazwa])
        splitted = nazwa.split
        case splitted.size
        when 2
          first_name, last_name = splitted
        when 3
          last_name = splitted.pop
          first_name = splitted.join(' ')
        else
          first_name = splitted.join(' ')
          last_name = nil
        end
        @splitted_names = [first_name, last_name]
      end

      def cap(text)
        text.capitalize!
        first_letter = text[0]
        replace_array = {
          'Ą' => 'ą',
          'Ó' => 'ó',
          'Ł' => 'ł',
          'Ń' => 'ń',
          'Ś' => 'ś',
          'Ż' => 'ż',
          'Ź' => 'ź',
          'Ę' => 'ę'
        }
        replaced = text[1..-1]
        replace_array.each { |k, v| replaced.gsub!(k, v) }
        replaced.prepend(first_letter)
        replaced.gsub!(' - ', '-')
        replaced.squish!
        replaced.split(' ').map(&:capitalize).map do |part_text|
          part_text.split('-').map(&:capitalize).join('-')
        end.join(' ')
      end

      def ids_of_existing_users
        @emails ||= @data.map { |row| row[:e_mail____1].presence || fill_blank_email(row) }
        @user_ids ||= event.accesses.where(email: @emails).ids
      end

      def remove(access)
        event.accesses.build(access.attributes.merge(removed_at: Time.zone.now))
      end

      def fill_blank_email(row)
        split_names(row).join(' ').split(' ').map(&:downcase).join('_').concat('@bez-maila.pl')
      end
  end
end
