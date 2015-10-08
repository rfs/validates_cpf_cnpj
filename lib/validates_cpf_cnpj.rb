require 'active_model'
require 'validates_cpf_cnpj/cpf'
require 'validates_cpf_cnpj/cnpj'

module ActiveModel
  module Validations
    class CpfOrCnpjValidator < ActiveModel::EachValidator
      include ValidatesCpfCnpj

      def validate_each(record, attr_name, value)
        return if should_skip?(record, attr_name, value)
        if value.to_s.gsub(/[^0-9]/, '').length <= 11
          validate_only_cpf(record, attr_name, value)
          normalize_cpf(record, attr_name, value)
        else
          validate_only_cnpj(record, attr_name, value)
          normalize_cnpj(record, attr_name, value)
        end
      end

      protected

      def should_skip?(record, attr_name, value)
        if ((options[:allow_nil] and value.nil?) or (options[:allow_blank] and value.blank?)) or
           ((options[:if] == false) or (options[:unless] == true)) or
           ((options[:on].to_s == 'create' and not record.new_record?) or (options[:on].to_s == 'update' and record.new_record?))
          true
        end
      end

      def validate_only_cpf(record, attr_name, value)
        return if should_skip?(record, attr_name, value)
        if (not value.to_s.match(/\A\d{11}\z/) and not value.to_s.match(/\A\d{3}\.\d{3}\.\d{3}\-\d{2}\z/)) or not Cpf.valid?(value)
          record.errors.add(attr_name)
        end
        normalize_cpf(record, attr_name, value)
      end

      def validate_only_cnpj(record, attr_name, value)
        return if should_skip?(record, attr_name, value)
        if (not value.to_s.match(/\A\d{14}\z/) and not value.to_s.match(/\A\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}\z/)) or not Cnpj.valid?(value)
          record.errors.add(attr_name)
        end
        normalize_cnpj(record, attr_name, value)
      end

      def normalize_cpf(record, attr_name, value)
        if value
          formatted = "#{value[0..2]}.#{value[3..5]}.#{value[6..8]}-#{value[9..10]}"
          record.send("#{attr_name}=", formatted)
        end
      end

      def normalize_cnpj(record, attr_name, value)
        if value
          formatted = "#{value[0..1]}.#{value[2..4]}.#{value[5..7]}/#{value[8..11]}-#{value[12..13]}"
          record.send("#{attr_name}=", formatted)
        end
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
