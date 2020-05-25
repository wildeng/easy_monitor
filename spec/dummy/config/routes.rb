Rails.application.routes.draw do
  mount EasyMonitor::Engine => '/easy_monitor'

  resources :users
end
