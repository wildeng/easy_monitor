# frozen_string_literal: true

module EasyMonitor
  module Util
    module Errors
      class NotWorking < StandardError
        def initialize(msg = 'Not working error', class_name = nil)
          msg += " for class #{class_name}" if class_name
          super(msg)
        end
      end
    end
  end
end
