module Volunteers
  module Helpers
    extend Grape::API::Helpers

    def authorize_user_role!
      error!('Unauthorized', 401) unless current_user&.volunteer?
    end
  end
end
