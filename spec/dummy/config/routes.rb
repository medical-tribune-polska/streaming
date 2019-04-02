Rails.application.routes.draw do
  mount Streaming::Engine => "/streaming"
end
