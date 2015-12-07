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
      NON_DIGITS_REGEXP = /[^0-9]/

      def validate_each(record, attr_name, value)
        return if should_skip?(record, attr_name, value)

        inside_cpf_length = value.to_s.gsub(NON_DIGITS_REGEXP, '').length <= 11

        if inside_cpf_length
          validate_only_cpf(record, attr_name, value)
        else
          validate_only_cnpj(record, attr_name, value)
        end
      end

    protected

      def should_skip?(record, attr_name, value)
        return true if (options[:allow_nil] && value.nil?) || (options[:allow_blank] && value.blank?)
        return true if (options[:if] == false) || (options[:unless] == true)
        return true if (options[:on].to_s == 'create' && !record.new_record?) || (options[:on].to_s == 'update' && record.new_record?)
        false
      end

      def validate_only_cpf(record, attr_name, value)
        return if should_skip?(record, attr_name, value)
        valid_cpf_format = value.to_s.match(ELEVEN_DIGITS_REGEXP) || value.to_s.match(CPF_FORMAT_REGEXP)

        if (valid_cpf_format && Cpf.valid?(value))
          format_cpf(record, attr_name, value)
        else
          add_error(record, attr_name)
        end
      end

      def validate_only_cnpj(record, attr_name, value)
        return if should_skip?(record, attr_name, value)
        valid_cnpj_format = value.to_s.match(FOURTEEN_DIGITS_REGEXP) || value.to_s.match(CNPJ_FORMAT_REGEXP)

        if (valid_cnpj_format && Cnpj.valid?(value))
          format_cnpj(record, attr_name, value)
        else
          add_error(record, attr_name)
        end
      end

      def add_error(record, attr_name)
        if options[:message]
          record.errors.add(attr_name, options[:message])
        else
          record.errors.add(attr_name)
        end
      end

      def format_cpf(record, attr_name, value)
        return unless value
        value.gsub!(NON_DIGITS_REGEXP, '')
        formatted_value = "#{value[0..2]}.#{value[3..5]}.#{value[6..8]}-#{value[9..10]}"
        record.send("#{attr_name}=", formatted_value)
      end

      def format_cnpj(record, attr_name, value)
        return unless value
        value.gsub!(NON_DIGITS_REGEXP, '')
        formatted_value = "#{value[0..1]}.#{value[2..4]}.#{value[5..7]}/#{value[8..11]}-#{value[12..13]}"
        record.send("#{attr_name}=", formatted_value)
      end
    end

    class CpfValidator < CpfOrCnpjValidator
      def validate_each(record, attr_name, value)
        validate_only_cpf(record, attr_name, value)
      end
    end

    class CnpjValidator < CpfOrCnpjValidator
      def validate_each(record, attr_name, value)
        validate_only_cnpj(record, attr_name, value)
      end
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
