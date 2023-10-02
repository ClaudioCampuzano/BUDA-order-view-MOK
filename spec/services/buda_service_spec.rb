# frozen_string_literal: true

require 'rails_helper'

describe BudaService do
  subject(:buda_service) { described_class }
  let(:market_a) { 'BTC-CLP' }
  let(:market_b) { 'ETH-PEN' }
  let(:higher_value_market_a) do
    ['1695935855001', '0.4', '100.0',
     'buy', 3]
  end
  let(:higher_value_market_b) do
    ['1695935855001', '0.233',
     '2300.0', 'sell', 6]
  end

  describe '#higher_value_trades' do
    before do
      allow(GetAvailableMarkets).to receive(:for).and_return [market_a, market_b]
      allow(GetHigherValueTrade).to receive(:for).with(market_id: market_a).and_return higher_value_market_a
      allow(GetHigherValueTrade).to receive(:for).with(market_id: market_b).and_return higher_value_market_b
    end
    let(:response) do
      { 'CLP' => [
          { market_id: market_a,
            timestamp: higher_value_market_a[0],
            amount: higher_value_market_a[1],
            price: higher_value_market_a[2],
            type: higher_value_market_a[3],
            id: higher_value_market_a[4] }
        ],
        'PEN' =>
        [{
          market_id: market_b,
          timestamp: higher_value_market_b[0],
          amount: higher_value_market_b[1],
          price: higher_value_market_b[2],
          type: higher_value_market_b[3],
          id: higher_value_market_b[4]
        }] }
    end

    it 'return correct values' do
      expect(buda_service.higher_value_trades).to eq response
    end
  end
end
