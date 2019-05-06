module EasyMonitor
  class Logger
    class << self
      def log
        logger = ::Logger.new(EasyMonitor::Engine::log_path)
      end
    end
  end
end
