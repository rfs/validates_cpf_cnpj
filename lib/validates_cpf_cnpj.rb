require 'active_model'
require 'validates_cpf_cnpj/cpf'
require 'validates_cpf_cnpj/cnpj'

module ActiveModel
  module Validations
    class CpfOrCnpjValidator < ActiveModel::EachValidator
      include ValidatesCpfCnpj

      def validate_each(record, attr_name, value)
        return if (options[:allow_nil] and value.nil?) or (options[:allow_blank] and value.blank?)
        return if (options[:if] == false) or (options[:unless] == true)
        return if (options[:on].to_s == 'create' and not record.new_record?) or (options[:on].to_s == 'update' and record.new_record?)

        if value.to_s.gsub(/[^0-9]/, '').length <= 11
          if (not value.to_s.match(/\A\d{11}\z/) and not value.to_s.match(/\A\d{3}\.\d{3}\.\d{3}\-\d{2}\z/)) or not Cpf.valid?(value)
            record.errors.add(attr_name)
          end
        else
          if (not value.to_s.match(/\A\d{14}\z/) and not value.to_s.match(/\A\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}\z/)) or not Cnpj.valid?(value)
            record.errors.add(attr_name)
          end
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
