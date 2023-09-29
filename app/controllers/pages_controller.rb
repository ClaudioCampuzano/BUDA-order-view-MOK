# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @higher_value_trades = BudaService.higher_value_trades
  end
end
