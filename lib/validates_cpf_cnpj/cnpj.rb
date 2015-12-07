module ValidatesCpfCnpj
  module Cnpj
    NON_DIGITS_REGEXP = /[^0-9]/
    FOURTEEN_PLUS_EQUAL_CHARACTERS_REGEXP = /\A(\d)\1{13,}\z/

    def self.valid?(value)
      value_only_digits = value.gsub(NON_DIGITS_REGEXP, '')

      return false if value_only_digits =~ FOURTEEN_PLUS_EQUAL_CHARACTERS_REGEXP

      digit = value_only_digits.slice(-2, 2)
      control = ''
      if value_only_digits.size == 14
        factor = 0
        2.times do |i|
          sum = 0;
          12.times do |j|
            sum += value_only_digits.slice(j, 1).to_i * ((11 + i - j) % 8 + 2)
          end
          sum += factor * 2 if i == 1
          factor = 11 - sum  % 11
          factor = 0 if factor > 9
          control << factor.to_s
        end
      end
      control == digit
    end
  end
end
