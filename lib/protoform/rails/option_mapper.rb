# frozen_string_literal: true

require "active_record"

module Protoform
  module Rails
    # Accept a collection of objects and map them to options suitable for form
    # controls, like `select > options`

    class OptionMapper
      include Enumerable

      def initialize(collection)
        @collection = collection
      end

      def each(&options)
        @collection.each do |object|
          case object
          in ActiveRecord::Relation => relation
            active_record_relation_options_enumerable(relation).each(&options)
          in id, value
            yield id, value
          in value
            yield value, value.to_s
          end
        end
      end

      def active_record_relation_options_enumerable(relation)
        Enumerator.new do |collection|
          relation.each do |object|
            attributes = object.attributes
            id = attributes.delete(relation.primary_key)
            value = attributes.values.join(" ")
            collection << [id, value]
          end
        end
      end
    end
  end
end
