module ValidatesCpfCnpj
  module Cnpj
    def self.valid?(value)
      sanitized_value = value.gsub(/[^0-9]/, '')
      digit = sanitized_value.slice(-2, 2)
      control = ''
      if sanitized_value.size == 14
        factor = 0
        2.times do |i|
          sum = 0;
          12.times do |j|
            sum += sanitized_value.slice(j, 1).to_i * ((11 + i - j) % 8 + 2)
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
