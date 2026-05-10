# frozen_string_literal: true

module EasyMonitor
  module Util
    module Errors
      class NotSetUp < StandardError
        def initialize(msg = 'Service is not set up', service_name = nil)
          msg += " for service #{service_name}" if service_name
          super(msg)
        end
      end
    end
  end
end
