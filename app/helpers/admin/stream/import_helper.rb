module Admin
  module Stream
    module ImportHelper
      def form_group_classes(*args, required: false)
        classes = errors_for_the_field(*args) ? %w[has-error] : []
        classes << 'required' if required
        classes
      end

      def form_group_classes_joined(*args, required: false)
        form_group_classes(*args, required: required).join(' ')
      end

      def error_messages(*args)
        if form_group_classes(*args).include?('has-error')
          content_tag(:span, errors_for_the_field(*args).uniq.join(', '), class: 'help-block')
        end
      end

      private

        def errors_for_the_field(*args)
          errors, i, field = *args
          errors.try(:[], i) && errors[i].key?(field.to_sym) && errors[i][field.to_sym]
        end
    end
  end
end
