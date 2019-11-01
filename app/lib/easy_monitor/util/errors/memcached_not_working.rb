module EasyMonitor
  module Util
    module Errors
      class MemcachedNotWorking < StandardError
        def initialize(msg = 'An error occurred', class_name = nil)
          msg += " for class #{class_name}" if class_name
          super(msg)
        end
      end
    end
  end
end
