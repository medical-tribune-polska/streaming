Rails.application.routes.draw do
  namespace :stream, defaults: { magazine_code: 'mw' } do
    resources :analytics, only: :create
    resources :accesses, path: '', param: :slug, only: :show
  end

  namespace :admin do
    namespace :stream do
      resources :events do
        resources :accesses, as: :stream_accesses do
          post :switch_removed, on: :member
          get :recount_watched_minutes, on: :collection
        end
        resources :import_links, as: :stream_import_links, only: %i[new create] do
          post :review, on: :collection
        end
        resources :import_users, as: :stream_import_users, only: %i[new create] do
          post :review, on: :collection
        end

        get :export_accesses, defaults: { format: 'csv' }
        get :currently_online
      end
    end
  end
end
