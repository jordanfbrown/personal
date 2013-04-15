Personal::Application.routes.draw do
  root :to => 'pages#home'
  match 'clock' => 'experiments#clock'
end
