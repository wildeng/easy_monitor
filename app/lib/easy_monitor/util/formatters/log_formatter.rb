module EasyMonitor
  module Util
    module Formatters
      class LogFormatter < ::Logger::Formatter
        def call(severity, time, programName, message)
          "#{datetime}, #{severity}: #{message} from #{programName}\n"
        end
      end
    end
  end
end
