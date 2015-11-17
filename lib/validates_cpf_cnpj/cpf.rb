module ValidatesCpfCnpj
  module Cpf
    @@invalid_cpfs = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000}
    NON_DIGITS_REGEXP = /[^0-9]/

    def self.valid?(value)
      value_only_digits = value.gsub(NON_DIGITS_REGEXP, '')

      return false if @@invalid_cpfs.member?(value_only_digits)

      digit = value_only_digits.slice(-2, 2)
      control = ''
      if value_only_digits.size == 11
        factor = 0
        2.times do |i|
          sum = 0
          9.times do |j|
            sum += value_only_digits.slice(j, 1).to_i * (10 + i - j)
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
