Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: "users/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

     root "posts#index"

     resources :posts do
       resources :comments, only: [:create, :edit, :update, :destroy]
       member do
         post :collect
         post :uncollect
       end
     end


      resources :users, except: [:index] do
        member do
          get :comments
          get :collects
          get :friends
          get :drafts
        end
      end

      resources :friendships, only: [:create] do
        member do
          post   :accept
          delete :ignore
        end
      end

      resources :feeds, only: :index
      resources :categories, only: :show



     namespace :admin do
       resources :categories
       resources :users, only: [:index] do
         member do
          post :update
         end
       end
       root "categories#index"
     end

     namespace :api, defaults: {format: :json} do
       namespace :v1 do
         post "/login"  =>  "auth#login"
         post "/logout"  =>  "auth#logout"
         resources :posts, except: [:edit]
       end
     end

end
