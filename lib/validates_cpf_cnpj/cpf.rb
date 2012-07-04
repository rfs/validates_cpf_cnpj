module ValidatesCpfCnpj
  module Cpf
    def self.valid?(value)
      value.gsub!(/[^0-9]/, '')
      digit = value.slice(-2, 2)
      control = ''
      if value.size == 11
        factor = 0
        2.times do |i|
          sum = 0
          9.times do |j|
            sum += value.slice(j, 1).to_i * (10 + i - j)
          end
          sum += (factor * 2) if i == 1
          factor = (sum * 10) % 11
          factor = 0 if factor == 10
          control << factor.to_s
        end
      end
      control == digit
    end
  end
end
