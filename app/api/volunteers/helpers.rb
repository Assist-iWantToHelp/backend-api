module Volunteers
  module Helpers
    include Common::Helpers

    def authorize_user_role!
      error!('Unauthorized', 401) unless current_user&.volunteer?
    end

    def week_aggregate_data(array)
      init_hash = {
        'Sunday' => 0,
        'Monday' => 0,
        'Tuesday' => 0,
        'Wednesday' => 0,
        'Thursday' => 0,
        'Friday' => 0,
        'Saturday' => 0
      }
      array.each_with_object(init_hash) { |need, hash| hash[need.status_updated_at.strftime('%A')] += 1 }
    end

    def completed_value(chart_data)
      completed = chart_data.delete('completed') || Array.new(7, 0)
      closed = chart_data.delete('closed') || Array.new(7, 0)
      [completed, closed].transpose.map { |x| x.reduce(:+) }
    end
  end
end
