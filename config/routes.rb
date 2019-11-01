EasyMonitor::Engine.routes.draw do
  get 'caching_checks/memcached_alive', to: 'caching_checks#memcached_alive'
  get 'caching_checks/redis_alive', to: 'caching_checks#redis_alive'
  get 'health_checks/alive', to: 'health_checks#alive'
  get 'health_checks/sidekiq_alive', to: 'health_checks#sidekiq_alive'
end
