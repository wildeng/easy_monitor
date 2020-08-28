# frozen_string_literal: true

module EasyMonitor
  module Util
    module Errors
      class HighQueueNumberError < StandardError
        def initialize(msg = 'Queue is too high', service_name = nil)
          msg += " for service #{service_name}" if service_name
          super(msg)
        end
      end
    end
  end
end
