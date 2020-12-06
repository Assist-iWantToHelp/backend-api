class Onesignal
  ONE_SIGNAL_API_URL = 'https://onesignal.com/api/v1/notifications'.freeze

  class << self
    def deliver_later(device_tokens, **payload)
      delay.deliver(device_tokens, payload)
    end

    def deliver(device_tokens, **payload)
      return unless device_tokens.any?

      uri = URI.parse(ONE_SIGNAL_API_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(
        uri.path,
        'Content-Type'  => 'application/json;charset=utf-8',
        'Authorization' => "Basic #{api_auth}"
      )
      request.body = build_request_body(device_tokens, payload).to_json
      http.request(request)
    end

    private

    def api_auth
      ENV.fetch('REST_API_KEY')
    end

    def app_id
      ENV.fetch('ONESIGNAL_APP_ID')
    end

    def build_request_body(device_tokens, **payload)
      body = payload_body(device_tokens, payload)
      body[:template_id] = template.template_id if template

      { app_id: app_id, content_available: true, **body }
    end

    def payload_body(device_tokens, **payload)
      { include_player_ids: device_tokens, **payload }
    end
  end
end
