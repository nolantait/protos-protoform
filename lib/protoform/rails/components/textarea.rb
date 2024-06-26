# frozen_string_literal: true

module Protoform
  module Rails
    module Components
      class Textarea < FieldComponent
        def view_template(&content)
          content ||= proc { dom.value }
          textarea(**attrs, &content)
        end
      end
    end
  end
end
