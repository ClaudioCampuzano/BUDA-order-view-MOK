# frozen_string_literal: true

class GetAvailableMarkets < PowerTypes::Command.new
  def perform
    markets
      .filter { |market| !market['disabled'] }
      .map { |market| market['id'] }
  end

  private

  def markets
    BudaClient.get_markets
  end
end
