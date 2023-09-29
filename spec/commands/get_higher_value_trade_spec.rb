# frozen_string_literal: true

require 'rails_helper'

describe GetHigherValueTrade do
  let(:market_id) { 'btc-clp' }
  let(:date) { Time.new(2023, 9, 29, 12, 0, 0, '+00:00') }

  def perform
    described_class.for(market_id:)
  end

  describe '#perform' do
    let(:response_whitout_timestamp) do
      { market_id: 'BTC-CLP',
        timestamp: nil,
        last_timestamp: '1695967855001',
        entries: [['1695970897176', '0.1', '100.0', 'buy', 0],
                  ['1695967855001', '0.3', '100.0', 'buy', 2]] }
    end
    let(:response_whit_timestamp) do
      { market_id: 'BTC-CLP',
        timestamp: '1695967855001',
        last_timestamp: '195967855001',
        entries: [['1695935855001', '0.4', '100.0', 'buy', 3],
                  ['195967855001', '0.6', '100.0', 'buy', 5]] }
    end
    before do
      Timecop.freeze(date)
      allow(BudaClient).to receive(:get_trades)
        .with(market_id:, timestamp: nil).and_return response_whitout_timestamp
      allow(BudaClient).to receive(:get_trades)
        .with(market_id:,
              timestamp: response_whitout_timestamp[:last_timestamp]).and_return response_whit_timestamp
    end

    it 'returns an array with the most valuable trade' do
      expect(perform).to eq response_whit_timestamp[:entries][0]
    end
  end
end
