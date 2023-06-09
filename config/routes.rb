Rails.application.routes.draw do
  get "shifts/new/:user_id/:date", to: 'shifts#new'
  get "shifts/edit/:user_id/:date", to: 'shifts#edit'
  get 'shifts/new'
  get "/notices", to: "shifts#notices" 
  get "/notice/new", to: "shifts#notice_new"
  get "/notice/:id/show", to: "shifts#notice_show"
  get "/notice/:id/edit", to:"shifts#notice_edit"
  root "shifts#home"
  get "event/new", to: "shifts#event_new"
  get "event/:id/edit", to:"shifts#event_edit"
  get "/events", to:"shifts#events"
  get "workdays/:date/show", to:"shifts#workday_show"

  get 'shifts', to: 'shifts#submission'
  get 'sessions/new'
  resources :users
  resources :shifts
  get "/users", to: "users#index"

  get 'register_shift', to: 'shifts#register_shift'
  get "all_shift", to: "shifts#all_shift"
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  get  "/register_shift/new/:user_id/:date", to: "shifts#workday_new"
  get  '/logout',  to: 'sessions#destroy'
  get  "/notice/:id/destroy", to: "shifts#notice_destroy"
  get  "/event/destroy/:id", to:"shifts#event_destroy"
  get  '/shifts/destroy/:format', to: 'shifts#destroy'
  get  "/register_shift/delete/:user_id/:date", to: "shifts#workday_destroy"
 
  
  post   '/login',   to: 'sessions#create'
  post  "/shifts/new/:user_id/:date",   to: 'shifts#create'
  post "/register_shift/new/:user_id/:date", to: "shifts#workday_create"
  post "notice/new", to: "shifts#notice_create"
  patch "notice/:id/update", to:"shifts#notice_update"
  post "event/new", to: "shifts#event_create"
  patch "event/:id/update", to:"shifts#event_update"
  patch "/shifts/update/:user_id/:date", to: 'shifts#update'

  delete "/notice/:id/destroy", to: "shifts#notice_destroy"
  delete "/event/destroy/:id", to:"shifts#event_destroy"
  delete '/shifts/destroy/:format', to: 'shifts#destroy'
  delete '/logout',  to: 'sessions#destroy'
  delete "/register_shift/delete/:user_id/:date", to: "shifts#workday_destroy"
end