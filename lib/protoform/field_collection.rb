# frozen_string_literal: true

module Protoform
  class FieldCollection
    include Enumerable

    def initialize(field:, &block)
      @field = field
      @index = 0
      each(&block) if block
    end

    def each
      Enumerator.new do |collection|
        values.each do |value|
          collection.yield build_field(value:)
        end
      end
    end

    def field
      build_field
    end

    def values
      Array(@field.value)
    end

    private

    def build_field(**)
      @field.class.new(current_index, parent: @field, **)
    end

    def current_index
      @index += 1
    end
  end
end
