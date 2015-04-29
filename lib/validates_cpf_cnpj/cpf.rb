module ValidatesCpfCnpj

  BLACKLIST = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000}

  module Cpf

    def self.clean(value)
      value.to_s.gsub(/[^0-9]/, '')
    end

    def self.blacklisted?(value, blacklist)
      if blacklist.is_a?(Proc)
        blacklist.call(value)
      elsif blacklist.is_a?(Array)
        blacklist.member?(self.clean(value))
      else
        self.blacklisted?(value, BLACKLIST) if blacklist
      end
    end

    def self.valid?(value)
      value = self.clean(value)

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
