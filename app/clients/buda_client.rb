# frozen_string_literal: true

class BudaClient
  BUDA_BASE_URL = ENV.fetch('BUDA_BASE_URL', 'https://www.buda.com/api/v2/')

  class << self
    def get_markets
      response = connection.get('markets')

      handle_response(response)['markets']
    end

    def get_trades(market_id:, timestamp: nil, limit: '100')
      response =
        connection.get("markets/#{market_id}/trades", { timestamp:, limit: })

      handle_response(response)['trades'].transform_keys(&:to_sym)
    end

    private

    def handle_response(response)
      raise ClientError::Buda.new(response.status, response.body) unless [200, 202].include?(response.status)

      response.body
    end

    def connection
      @connection ||=
        Faraday.new(url: BUDA_BASE_URL) do |f|
          f.request :json
          f.response :json
        end
    end
  end
end
