# http://stackoverflow.com/questions/29388777/rspec-expect-to-change-multiple
module RSpec
  module Matchers
    def change_multiple(receiver=nil, message=nil, &block)
      BuiltIn::ChangeMultiple.new(receiver, message, &block)
    end

    module BuiltIn
      class ChangeMultiple < Change
        def with_expectations(expectations)
          # What to do here? How do I add the expectations passed as argument?
        end
      end
    end
  end
end
