# frozen_string_literal: true

module EasyMonitor
  module Util
    module Errors
      class NotUsed < StandardError
        def initialize(msg = 'Not used error', class_name = nil)
          msg += " for class #{class_name}" if class_name
          super(msg)
        end
      end
    end
  end
end
