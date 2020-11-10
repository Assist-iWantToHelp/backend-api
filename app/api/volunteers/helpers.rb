module Volunteers
  module Helpers
    include Common::Helpers

    def authorize_user_role!
      error!('Unauthorized', 401) unless current_user&.volunteer?
    end
  end
end
