# frozen_string_literal: true

require 'rails_helper'

describe BudaClient do
  let(:client) { described_class }
  let(:status) { 200 }
  let(:faraday_response) { instance_double(Faraday::Response, body: response_hash, status:) }
  let(:connection) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return connection
    allow(connection).to receive(:get).and_return faraday_response
  end

  after { client.instance_variable_set(:@connection, nil) }

  describe '#get_markets' do
    let(:response_hash) { { 'markets' => [{ 'id' => 'BTC-CLP' }, { 'id' => 'btc-cop' }] } }

    it 'returns hash with markets' do
      expect(client.get_markets).to eq response_hash['markets']
    end

    context 'when the api responds with 200' do
      before { client.get_markets }

      it 'creates a new connection with the correct url' do
        expect(Faraday).to have_received(:new).with(url: 'https://www.buda.com/api/v2/')
      end

      it 'calls with the correct method and path' do
        expect(connection).to have_received(:get)
                          .with('markets')
      end
    end

    context 'when the api does not respond with 200' do
      let(:status) { 500 }

      it 'raises a PricesCollectorError' do
        expect { client.get_markets }
          .to raise_error(ClientError::Buda)
      end
    end
  end

  describe '#get_trades' do
    let(:response_hash) { { 'trades' => { 'market_id' => 'BTC-CLP', 'entries' => [] } } }
    let(:market_id) { 'btc-clp' }
    it 'returns hash with trades' do
      expect(client.get_trades(market_id:)).to eq response_hash['trades'].transform_keys(&:to_sym)
    end

    context 'when the api responds with 200' do
      before { client.get_trades(market_id:) }

      it 'creates a new connection with the correct url' do
        expect(Faraday).to have_received(:new).with(url: 'https://www.buda.com/api/v2/')
      end

      it 'calls with the correct method and path' do
        expect(connection).to have_received(:get)
                          .with("markets/#{market_id}/trades", { limit: '100', timestamp: nil })
      end
    end

    context 'when the api does not respond with 200' do
      let(:status) { 500 }

      it 'raises a PricesCollectorError' do
        expect { client.get_trades(market_id:) }
          .to raise_error(ClientError::Buda)
      end
    end
  end
end
