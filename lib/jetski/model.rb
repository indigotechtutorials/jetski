module Jetski
  class Model
    extend Jetski::Database::Base
    class << self
      def create(**args)
        return puts "#{table_name.capitalize}.create was called with no args" if args.size == 0
        question_mark_args = (1..args.size).map { |n| "?" }.join(", ")
        db.execute "insert into #{pluralized_table_name} values ( #{question_mark_args} )", args
      end

      def attributes
        
      end
    private
      def table_name
        self.to_s.downcase
      end

      def pluralized_table_name
        if table_name[-1] == "s"
          table_name
        else
          table_name + "s"
        end
      end
    end
  end
end