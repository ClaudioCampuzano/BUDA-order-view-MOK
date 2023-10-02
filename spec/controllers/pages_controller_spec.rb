# frozen_string_literal: true

require 'rails_helper'

describe PagesController, type: :controller do
  describe '#home' do
    let(:buda_higher_value_trades) do
      { 'CLP' => [{ market_id: 'btc-clp', amount: 0.2346, price: 24_000, type: 'sell' }],
        'PEN' => [{ market_id: 'btc-pen', amount: 0.9344, price: 22_000, type: 'buy' }] }
    end

    before do
      allow(BudaService).to(receive(:higher_value_trades).and_return(buda_higher_value_trades))
    end

    it 'returns an 200 status' do
      get :home
      expect(response).to have_http_status :success
    end

    context 'when cache is enabled' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      context 'when there is nothing stored on cache' do
        it 'returns the correct unstored value' do
          get :home

          expect(assigns(:higher_value_trades)).to eq buda_higher_value_trades
        end
      end

      context 'when there is something stored on cache' do
        before do
          Rails.cache.write('buda_higher_value_trades', buda_higher_value_trades)
        end

        it 'returns the value stored on cache' do
          get :home

          expect(assigns(:higher_value_trades)).to eq buda_higher_value_trades
        end
      end
    end
  end
end
