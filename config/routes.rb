Personal::Application.routes.draw do
  root :to => 'pages#home'
  match 'clock' => 'experiments#clock'
  match 'd3' => 'experiments#d3'
end
