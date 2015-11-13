require 'active_model'
require 'validates_cpf_cnpj/cpf'
require 'validates_cpf_cnpj/cnpj'

module ActiveModel
  module Validations
    class CpfOrCnpjValidator < ActiveModel::EachValidator
      include ValidatesCpfCnpj

      ELEVEN_DIGITS_REGEXP = /\A\d{11}\z/
      FOURTEEN_DIGITS_REGEXP = /\A\d{14}\z/
      CPF_FORMAT_REGEXP = /\A\d{3}\.\d{3}\.\d{3}\-\d{2}\z/
      CNPJ_FORMAT_REGEXP = /\A\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}\z/
      NOT_DIGITS_REGEXP = /[^0-9]/

      def validate_each(record, attr_name, value)
        return if (options[:allow_nil] && value.nil?) || (options[:allow_blank] && value.blank?)
        return if (options[:if] == false) || (options[:unless] == true)
        return if (options[:on].to_s == 'create' && !record.new_record?) || (options[:on].to_s == 'update' && record.new_record?)

        inside_cpf_length = value.to_s.gsub(NOT_DIGITS_REGEXP, '').length <= 11
        valid_cpf_format = value.to_s.match(ELEVEN_DIGITS_REGEXP) || value.to_s.match(CPF_FORMAT_REGEXP)
        valid_cnpj_format = value.to_s.match(FOURTEEN_DIGITS_REGEXP) || value.to_s.match(CNPJ_FORMAT_REGEXP)

        value_is_invalid = inside_cpf_length && !(valid_cpf_format && Cpf.valid?(value))
        value_is_invalid |= !inside_cpf_length && !(valid_cnpj_format && Cnpj.valid?(value))

        return unless value_is_invalid

        if options[:message]
          record.errors.add(attr_name, options[:message])
        else
          record.errors.add(attr_name)
        end
      end
    end

    class CpfValidator < CpfOrCnpjValidator
    end

    class CnpjValidator < CpfOrCnpjValidator
    end

    module HelperMethods
      def validates_cpf(*attr_names)
        raise ArgumentError, "You need to supply at least one attribute" if attr_names.empty?
        validates_with CpfValidator, _merge_attributes(attr_names)
      end

      def validates_cnpj(*attr_names)
        raise ArgumentError, "You need to supply at least one attribute" if attr_names.empty?
        validates_with CnpjValidator, _merge_attributes(attr_names)
      end

      def validates_cpf_or_cnpj(*attr_names)
        raise ArgumentError, "You need to supply at least one attribute" if attr_names.empty?
        validates_with CpfOrCnpjValidator, _merge_attributes(attr_names)
      end
    end
  end
end
