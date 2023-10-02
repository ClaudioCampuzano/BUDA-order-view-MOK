# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @higher_value_trades = Rails.cache.fetch('buda_higher_value_trades', expires_in: 1.minute) do
      BudaService.higher_value_trades
    end
  end
end
