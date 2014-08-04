module ActiveAdmin
  module Filters
    module FormtasticAddons
      def klass
        @object.class
      end

      def polymorphic_foreign_type?(method)
        false
      end
    end
  end
end

module Mongoid
  module Document
    def self.included(base)
      base.class_eval do
        def self.primary_key
          'id'
        end
      end
    end
  end
end