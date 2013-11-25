require "has_dynamic_status_types/version"
module HasDynamicStatusTypes
  require "has_dynamic_status_types/association"
  require "dynamic_status"
  require "dynamic_status/lookup"

  # monkey-patch ActiveRecord::Base
  #  - creates instance methods on the class to interact with the defined status types
  ::ActiveRecord::Base.class_eval do
    def self.has_dynamic_status_types( *args )

      attrs = [args].flatten

      has_many :status_types, as: 'status_typeable', class_name: HasDynamicStatusTypes::Association

      attrs.each do |attr|

        base_method_name = "#{attr}_status".to_sym
        find_method_name = "fetch_#{base_method_name}".to_sym
        hist_method_name = "hist_#{base_method_name}".to_sym

        define_method find_method_name do
          status_type = status_types.find { |st| st.status_type == attr }
        end

        define_method base_method_name do
          status_type = send(find_method_name)
          return unless status_type
          ::DynamicStatus.new(self, attr, status_type.current_status_code)
        end

        define_method "#{base_method_name}=" do |new_status_code|
          status_type = send(find_method_name)
          unless status_type  # do we need to create the record?
            status_type = status_types.build(status_type: attr, current_status_code: new_status_code)
          end
          old = status_type.current_status_code
          unless old == new_status_code # do we need to change the code?
            status_type.update_attributes(current_status_code: new_status_code)
          end
          ::DynamicStatus.new(self, attr, new_status_code)
        end

        define_method hist_method_name do
          status_type = send(find_method_name)
          return unless status_type
          status_type.history.map do |old|
            ::DynamicStatus.new(self, attr, old[:code])
          end
        end

      end
    end
  end
end
