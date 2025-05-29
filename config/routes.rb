Rails.application.routes.draw do
  # Autenticación para administradores con Devise + ActiveAdmin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Página principal redirige al dashboard de ActiveAdmin
  root to: "admin/dashboard#index"

  # Rutas públicas (solo lectura por ahora, sin autenticación)
  resources :clients, only: [:index, :show]
  resources :orders, only: [:index, :show]
  resources :products, only: [:index, :show]
  resources :providers, only: [:index, :show]
  resources :employees, only: [:index, :show]

  # Aquí puedes agregar más rutas públicas si tu sistema lo requiere
  # Por ejemplo:
  # get '/menu', to: 'products#menu'
end
