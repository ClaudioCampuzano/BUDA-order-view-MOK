# frozen_string_literal: true

require 'rails_helper'

describe 'pages/home.html.erb', type: :view do
  before(:each) do
    @higher_value_trades = { 'CLP' =>
    [{ market_id: 'BTC-CLP', timestamp: '16959130', amount: '0.71081301', price: '24175435.0', type: 'buy', id: 0 },
     { market_id: 'ETH-CLP', timestamp: '16959762', amount: '6.94', price: '1492748.0', type: 'sell', id: 1 },
     { market_id: 'LTC-CLP', timestamp: '16959137', amount: '168.18861775', price: '59099.0', type: 'buy', id: 2 }],
                             'PEN' =>
    [{ market_id: 'BTC-PEN', timestamp: '16959179', amount: '0.14118254', price: '102368.77', type: 'buy', id: 3 },
     { market_id: 'ETH-PEN', timestamp: '16959340', amount: '1.02', price: '6179.0', type: 'buy', id: 4 },
     { market_id: 'LTC-PEN', timestamp: '1695908', amount: '3.48973794', price: '234.85', type: 'sell', id: 5 }],
                             'COP' =>
    [{ market_id: 'BTC-COP', timestamp: '16955415', amount: '0.11957662', price: '108899999.79', type: 'buy', id: 6 },
     { market_id: 'ETH-COP', timestamp: '16959131', amount: '0.798962569', price: '6498995.0', type: 'buy', id: 7 },
     { market_id: 'LTC-COP', timestamp: '169593848', amount: '9.26608738', price: '251068.02', type: 'sell', id: 8 }] }
    assign(:higher_value_trades, @higher_value_trades)
    render
  end

  it 'should display the buttons for each base_currency' do
    @higher_value_trades.each_key do |base_currency|
      expect(rendered).to have_selector("button[data-target='#{base_currency}']", text: I18n.t(base_currency))
    end
  end

  it 'should the information in the tables' do
    @higher_value_trades.each do |base_currency, trades|
      trades.each do |trade|
        expect(rendered).to have_selector("table##{base_currency} td",
                                          text: Time.zone.at(trade[:timestamp].to_i / 1000)
                                          .strftime('%d/%m/%Y %H:%M:%S'))
        expect(rendered).to have_selector("table##{base_currency} td", text: trade[:market_id])
        expect(rendered).to have_selector("table##{base_currency} td", text: I18n.t(trade[:type]))
      end
    end
  end
end
