# frozen_string_literal: true

require 'rails_helper'

describe GetAvailableMarkets do
  def perform
    described_class.for
  end

  describe '#perform' do
    let(:response) do
      [{ 'id' => 'BTC-CLP',
         'disabled' => false },
       { 'id' => 'BTC-COP',
         'disabled' => false }, { 'id' => 'BTC-PEN',
                                  'disabled' => false }, { 'id' => 'BTC-ARS',
                                                           'disabled' => true }]
    end
    before do
      allow(BudaClient).to receive(:get_markets).and_return response
    end

    it 'return id of available markets' do
      expect(perform).to eq %w[BTC-CLP BTC-COP BTC-PEN]
    end
  end
end
