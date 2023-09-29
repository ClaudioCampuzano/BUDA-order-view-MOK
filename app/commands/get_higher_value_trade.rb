# frozen_string_literal: true

class GetHigherValueTrade < PowerTypes::Command.new(:market_id)
  def perform
    accummulate_trades = trades_until_last_timestamp_not_less_than_24_hourse

    accummulate_trades.max_by { |trade| trade[1].to_f * trade[2].to_f }
  end

  private

  def trades_until_last_timestamp_not_less_than_24_hourse
    last_timestamp = nil
    acummulate_entries = []

    loop do
      trades_data = trades(last_timestamp)

      trades_data => { last_timestamp:, entries: }
      valid_entries =
        entries.filter { |entrie| !timestamps_over_24_hours?(entrie[0]) }
      acummulate_entries.concat(valid_entries)

      break if valid_entries.empty? || timestamps_over_24_hours?(last_timestamp)
    end

    acummulate_entries
  end

  def timestamps_over_24_hours?(timestamp)
    time_difference = Time.now.to_i - timestamp.to_i / 1_000

    time_difference > 24 * 60 * 60
  end

  def trades(timestamp)
    BudaClient.get_trades(market_id: @market_id, timestamp:)
  end
end
