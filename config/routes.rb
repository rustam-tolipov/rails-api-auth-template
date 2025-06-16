Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
        controllers: {
          registrations: "api/v1/users/registrations",
          sessions: "api/v1/users/sessions"
        },
        path: "",
        path_names: {
          sign_in: "login",
          sign_out: "logout",
          registration: "signup"
        }
    end
  end
end
