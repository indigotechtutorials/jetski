require "pry"

module Jetski
  module Helpers
    module Delegatable
      # delegate(:method, to: :class)
      # Allows you to delegate a method to another class
      def delegate(*delegatables, to:)
        delegatables.each do |method_name|
          define_method method_name do
            self.public_send(to).send(method_name)
          end
        end
      end
    end
  end
end