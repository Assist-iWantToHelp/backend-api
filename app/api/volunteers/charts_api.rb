module Volunteers
  class ChartsApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :charts do
      desc 'Charts for all needs' do
        tags %w[charts]
        http_codes [
          { code: 200, message: 'Charts for all needs details' }
        ]
      end
      get :all_needs do
        chart_data = Need.where(deleted: false)
          .select(:status, :status_updated_at)
          .group_by(&:status)
          .transform_values { |v| week_aggregate_data(v) }
          .transform_values(&:values)
        chart_data['completed'] = completed_value(chart_data)
        chart_data['deleted'] = week_aggregate_data(Need.where(deleted: true)
          .select(:status, :status_updated_at)).values
        chart_data['in_progress'] ||= Array.new(7, 0)
        chart_data['opened'] ||= Array.new(7, 0)

        { 'all_needs' => chart_data }
      end

      desc 'Charts for my chosen needs' do
        tags %w[charts]
        http_codes [
          { code: 200, message: 'Charts for my chosen needs details' }
        ]
      end
      get :user_needs do
        chart_data = current_user.chosen_needs.where(deleted: false)
          .select(:status, :status_updated_at)
          .group_by(&:status)
          .transform_values { |v| week_aggregate_data(v) }
          .transform_values(&:values)
        chart_data['completed'] = completed_value(chart_data)
        chart_data['deleted'] = week_aggregate_data(current_user.chosen_needs
          .where(deleted: true).select(:status, :status_updated_at)).values
        chart_data['in_progress'] ||= Array.new(7, 0)
        chart_data['opened'] ||= Array.new(7, 0)

        { 'user_needs' => chart_data }
      end

      desc 'Charts for my needs' do
        tags %w[charts]
        http_codes [
          { code: 200, message: 'Charts for my needs details' }
        ]
      end
      get :user_recomended_needs do
        chart_data = current_user.my_needs.where(deleted: false)
          .select(:status, :status_updated_at)
          .group_by(&:status)
          .transform_values { |v| week_aggregate_data(v) }
          .transform_values(&:values)
        chart_data['completed'] = completed_value(chart_data)
        chart_data['deleted'] = week_aggregate_data(current_user.my_needs
          .where(deleted: true).select(:status, :status_updated_at)).values
        chart_data['in_progress'] ||= Array.new(7, 0)
        chart_data['opened'] ||= Array.new(7, 0)

        { 'user_recomended_needs' => chart_data }
      end
    end
  end
end
