Personal::Application.routes.draw do
  root :to => 'pages#home'
  match 'experiments/clock' => 'experiments#clock'
  match 'experiments/circles' => 'experiments#circles'
  match 'experiments/tetris' => 'experiments#tetris'
  match 'experiments' => 'experiments#index'
end


