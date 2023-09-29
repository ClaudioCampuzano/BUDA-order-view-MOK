# frozen_string_literal: true

require 'rails_helper'

describe PagesController, type: :controller do
  describe '#home' do
    before do
      allow(BudaService).to receive(:higher_value_trades).and_return 'ipsum'
    end

    it 'returns an 200 status' do
      get :home
      expect(response).to have_http_status(:success)
    end
  end
end
