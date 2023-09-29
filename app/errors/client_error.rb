# frozen_string_literal: true

module ClientError
  class Buda < StandardError
    attr_reader :status, :detail

    def initialize(status, detail)
      super("Buda error: #{status} #{detail}")

      @status = status
      @detail = detail
    end
  end
end
