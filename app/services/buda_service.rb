# frozen_string_literal: true

class BudaService
  class << self
    QUOTE_ORDER_PATTERN = %w[BTC ETH BCH USDC LTC USDT].freeze
    BASE_ORDER_PATTERN = %w[CLP PEN COP].freeze

    def higher_value_trades
      results = []
      threads = []

      available_markets_id.each do |market_id|
        threads << Thread.new do
          timestamp, amount, price, type, id =
            GetHigherValueTrade.for(market_id:)

          results << ({ market_id:, timestamp:, amount:, price:, type:, id: }) unless timestamp.nil?
        end
      end

      threads.each(&:join)

      group_trades sort_trades results
    end

    private

    def sort_trades(trades)
      trades.sort_by do |trade|
        quote, base = trade[:market_id].split('-')
        [
          QUOTE_ORDER_PATTERN.index(quote)&.to_i || Float::INFINITY,
          BASE_ORDER_PATTERN.index(base)&.to_i || Float::INFINITY
        ]
      end
    end

    def group_trades(trades)
      trades.group_by do |hash|
        _, base = hash[:market_id].split('-')
        base
      end
    end

    def available_markets_id
      @available_markets_id = GetAvailableMarkets.for
    end
  end
end
