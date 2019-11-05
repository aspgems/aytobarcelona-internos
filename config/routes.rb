Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get '/users/sign_in', to: redirect { |path_params, req| "/users/auth/saml?#{req.params.to_query}" }, as: :new_user_session
  get '/users/sign_up', to: redirect { |path_params, req| "/users/auth/saml?#{req.params.to_query}" }, as: :new_user_registration

  mount Decidim::Core::Engine => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
