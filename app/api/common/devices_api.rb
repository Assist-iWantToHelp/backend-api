module Common
  class DevicesApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :devices do
      desc 'Devices for current_user' do
        tags %w[devices]
        http_codes [
          { code: 200, model: Entities::Device, message: 'Devices list' }
        ]
      end
      get do
        devices = current_user.devices
        present devices, with: Entities::Device
      end

      desc 'Add OneSignal device' do
        tags %w[devices]
        http_codes [
          { code: 201, model: Entities::Device, message: 'Device created' },
          { code: 400, message: 'Params are invalid' }
        ]
      end
      params do
        with(documentation: { in: 'body' }) do
          requires :signal_id, type: String, desc: 'OneSignal ID', allow_blank: false
        end
      end
      post do
        device = current_user.devices.create!(params)
        present device, with: Entities::Device
      end
    end
  end
end
