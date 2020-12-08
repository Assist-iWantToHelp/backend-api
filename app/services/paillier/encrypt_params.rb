module Paillier
  class EncryptParams < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      encrypt_values
    end

    private

    attr_reader :params

    def public_key
      Paillier::PublicKey.from_s(ENV['PAILLIER_PUBLIC'])
    end

    def encrypt_values
      transformed_params = {}
      sum = paillier_encryption(0)

      params.each do |k, v|
        encrypted_value = paillier_encryption(v.to_i)
        sum = Paillier.eAdd(public_key, sum, encrypted_value)
        transformed_params[k] = encrypted_value.to_s
      end

      transformed_params[:total] = sum.to_s
      transformed_params
    end

    def paillier_encryption(value)
      Paillier.encrypt(public_key, value)
    end
  end
end
