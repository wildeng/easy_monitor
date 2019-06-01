module EasyMonitor
  module Log
    class LogFormatter < Logger::Formatter
      def call(severity, time, programName, message)
        "#{time}, #{severity}: #{message} from #{programName}\n"
      end
    end
  end
end
