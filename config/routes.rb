# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Volunteers::RootApi => '/volunteers/api/v1'
  mount HelpSeekers::RootApi => '/help_seekers/api/v1'
end
