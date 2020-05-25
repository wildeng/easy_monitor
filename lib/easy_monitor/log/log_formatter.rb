# frozen_string_literal: true

module EasyMonitor
  module Log
    class LogFormatter < Logger::Formatter
      def call(severity, time, program_name, message)
        "#{time}, #{severity}: #{message} from #{program_name}\n"
      end
    end
  end
end
