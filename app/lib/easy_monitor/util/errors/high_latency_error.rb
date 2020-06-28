# frozen_string_literal: true

module EasyMonitor
  module Util
    module Errors
      class HighLatencyError < StandardError
        def initialize(msg = 'High latency error', class_name = nil)
          msg += " for class #{class_name}" if class_name
          super(msg)
        end
      end
    end
  end
end
