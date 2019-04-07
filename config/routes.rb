EasyMonitor::Engine.routes.draw do
  get 'health_checks/alive', to: 'health_checks#alive'
end
