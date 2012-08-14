require 'spec_helper'

describe ValidatesCpfCnpj do
  describe 'validates_cpf' do
    it 'should raise an ArgumentError when no attribute is informed' do
      person = Person.new
      lambda { person.validates_cpf }.should raise_exception(ArgumentError, 'You need to supply at least one attribute')
    end

    context 'should be invalid when' do
      invalid_cpfs = %w{1234567890 12345678901 ABC45678901 123.456.789-01 800337.878-83 800337878-83}
      
      invalid_cpfs.each do |cpf|
        it "value is #{cpf}" do
          person = Person.new(:code => cpf)
          person.validates_cpf(:code)
          person.errors.should_not be_empty
        end
      end

      it 'value is nil' do
        person = Person.new(:code => nil)
        person.validates_cpf(:code)
        person.errors.should_not be_empty
      end

      it 'value is empty' do
        person = Person.new(:code => '')
        person.validates_cpf(:code)
        person.errors.should_not be_empty
      end

      # This numbers will be considered valid by the algorithm but is known as not valid on real world, so they should be blocked
      blocked_cpfs = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000}

      blocked_cpfs.each do |cpf|
        it "is a well know invalid number: #{cpf}" do
          person = Person.new(:code => cpf)
          person.validates_cpf(:code)
          person.errors.should_not be_empty
        end
      end
    end

    context 'should be valid when' do
      it 'value is 80033787883' do
        person = Person.new(:code => '80033787883')
        person.validates_cpf(:code)
        person.errors.should be_empty
      end

      it 'value is 800.337.878-83' do
        person = Person.new(:code => '800.337.878-83')
        person.validates_cpf(:code)
        person.errors.should be_empty
      end

      it 'value is nil and :allow_nil or :allow_blank is true' do
        person = Person.new(:code => nil)
        person.validates_cpf(:code, :allow_nil => true)
        person.errors.should be_empty
        person.validates_cpf(:code, :allow_blank => true)
        person.errors.should be_empty
      end

      it 'value is empty and :allow_blank is true' do
        person = Person.new(:code => '')
        person.validates_cpf(:code, :allow_blank => true)
        person.errors.should be_empty
        person.validates_cpf(:code, :allow_nil => true)
        person.errors.should_not be_empty
      end

      it ':if option evaluates false' do
        person = Person.new(:code => '12345678901')
        person.validates_cpf(:code, :if => false)
        person.errors.should be_empty
      end

      it ':unless option evaluates true' do
        person = Person.new(:code => '12345678901')
        person.validates_cpf(:code, :unless => true)
        person.errors.should be_empty
      end

      it ':on option is :create and the model instance is not a new record' do
        person = Person.new(:code => '12345678901')
        person.stub!(:new_record?, false)
        person.validates_cpf(:code, :on => :create)
        person.errors.should be_empty
      end

      it ':on option is :update and the model instance is a new record' do
        person = Person.new(:code => '12345678901')
        person.validates_cpf(:code, :on => :update)
        person.errors.should be_empty
      end
    end
  end

  describe 'validates_cnpj' do
    it 'should raise an ArgumentError when no attribute is informed' do
      person = Person.new
      lambda { person.validates_cnpj }.should raise_exception(ArgumentError, 'You need to supply at least one attribute')
    end

    context 'should be invalid when' do

      invalid_cnpjs = %w{1234567890123 12345678901234 123456789012345 ABC05393625000184 12.345.678/9012-34 05393.625/0001-84 05393.6250001-84}

      invalid_cnpjs.each do |cnpj|
        it "value is #{cnpj}" do
          person = Person.new(:code => cnpj)
          person.validates_cnpj(:code)
          person.errors.should_not be_empty
        end
      end
      

      it 'value is nil' do
        person = Person.new(:code => nil)
        person.validates_cnpj(:code)
        person.errors.should_not be_empty
      end

      it 'value is empty' do
        person = Person.new(:code => '')
        person.validates_cnpj(:code)
        person.errors.should_not be_empty
      end
    end

    context 'should be valid when' do
      it 'value is 05393625000184' do
        person = Person.new(:code => '05393625000184')
        person.validates_cnpj(:code)
        person.errors.should be_empty
      end

      it 'value is 05.393.625/0001-84' do
        person = Person.new(:code => '05.393.625/0001-84')
        person.validates_cnpj(:code)
        person.errors.should be_empty
      end

      it 'value is nil and :allow_nil or :allow_blank is true' do
        person = Person.new(:code => nil)
        person.validates_cnpj(:code, :allow_nil => true)
        person.errors.should be_empty
        person.validates_cnpj(:code, :allow_blank => true)
        person.errors.should be_empty
      end

      it 'value is empty and :allow_blank is true' do
        person = Person.new(:code => '')
        person.validates_cnpj(:code, :allow_blank => true)
        person.errors.should be_empty
        person.validates_cnpj(:code, :allow_nil => true)
        person.errors.should_not be_empty
      end

      it ':if option evaluates false' do
        person = Person.new(:code => '12345678901234')
        person.validates_cnpj(:code, :if => false)
        person.errors.should be_empty
      end

      it ':unless option evaluates true' do
        person = Person.new(:code => '12345678901234')
        person.validates_cnpj(:code, :unless => true)
        person.errors.should be_empty
      end

      it ':on option is :create and the model instance is not a new record' do
        person = Person.new(:code => '12345678901')
        person.stub!(:new_record?, false)
        person.validates_cnpj(:code, :on => :create)
        person.errors.should be_empty
      end

      it ':on option is :update and the model instance is a new record' do
        person = Person.new(:code => '12345678901')
        person.validates_cnpj(:code, :on => :update)
        person.errors.should be_empty
      end
    end
  end

  describe 'validates_cpf_or_cnpj' do
    it 'should raise an ArgumentError when no attribute is informed' do
      person = Person.new
      lambda { person.validates_cpf_or_cnpj }.should raise_exception(ArgumentError, 'You need to supply at least one attribute')
    end

    context 'should be invalid when' do

      invalid_numbers = %w{1234567890 12345678901 ABC45678901 123.456.789-01 800337.878-83 800337878-83 1234567890123 12345678901234 123456789012345 ABC05393625000184 12.345.678/9012-34 05393.625/0001-84 05393.6250001-84}
      invalid_numbers.each do |number|
        it "value is #{number}" do
          person = Person.new(:code => number)
          person.validates_cpf_or_cnpj(:code)
          person.errors.should_not be_empty
        end
      end

      it 'value is nil' do
        person = Person.new(:code => nil)
        person.validates_cpf_or_cnpj(:code)
        person.errors.should_not be_empty
      end

      it 'value is empty' do
        person = Person.new(:code => '')
        person.validates_cpf_or_cnpj(:code)
        person.errors.should_not be_empty
      end
    end

    context 'should be valid when' do
      it 'value is 80033787883' do
        person = Person.new(:code => '80033787883')
        person.validates_cpf_or_cnpj(:code)
        person.errors.should be_empty
      end

      it 'value is 800.337.878-83' do
        person = Person.new(:code => '800.337.878-83')
        person.validates_cpf_or_cnpj(:code)
        person.errors.should be_empty
      end

      it 'value is nil and :allow_nil or :allow_blank is true' do
        person = Person.new(:code => nil)
        person.validates_cpf_or_cnpj(:code, :allow_nil => true)
        person.errors.should be_empty
        person.validates_cpf_or_cnpj(:code, :allow_blank => true)
        person.errors.should be_empty
      end

      it 'value is empty and :allow_blank is true' do
        person = Person.new(:code => '')
        person.validates_cpf_or_cnpj(:code, :allow_blank => true)
        person.errors.should be_empty
        person.validates_cpf_or_cnpj(:code, :allow_nil => true)
        person.errors.should_not be_empty
      end

      it ':if option evaluates false' do
        person = Person.new(:code => '12345678901')
        person.validates_cpf_or_cnpj(:code, :if => false)
        person.errors.should be_empty
      end

      it ':unless option evaluates true' do
        person = Person.new(:code => '12345678901')
        person.validates_cpf_or_cnpj(:code, :unless => true)
        person.errors.should be_empty
      end

      it ':on option is :create and the model instance is not a new record' do
        person = Person.new(:code => '12345678901')
        person.stub!(:new_record?, false)
        person.validates_cpf_or_cnpj(:code, :on => :create)
        person.errors.should be_empty
      end

      it ':on option is :update and the model instance is a new record' do
        person = Person.new(:code => '12345678901')
        person.validates_cpf_or_cnpj(:code, :on => :update)
        person.errors.should be_empty
      end

      it 'value is 05393625000184' do
        person = Person.new(:code => '05393625000184')
        person.validates_cpf_or_cnpj(:code)
        person.errors.should be_empty
      end

      it 'value is 05.393.625/0001-84' do
        person = Person.new(:code => '05.393.625/0001-84')
        person.validates_cpf_or_cnpj(:code)
        person.errors.should be_empty
      end

      it 'value is nil and :allow_nil or :allow_blank is true' do
        person = Person.new(:code => nil)
        person.validates_cpf_or_cnpj(:code, :allow_nil => true)
        person.errors.should be_empty
        person.validates_cpf_or_cnpj(:code, :allow_blank => true)
        person.errors.should be_empty
      end

      it 'value is empty and :allow_blank is true' do
        person = Person.new(:code => '')
        person.validates_cpf_or_cnpj(:code, :allow_blank => true)
        person.errors.should be_empty
        person.validates_cpf_or_cnpj(:code, :allow_nil => true)
        person.errors.should_not be_empty
      end

      it ':if option evaluates false' do
        person = Person.new(:code => '12345678901234')
        person.validates_cpf_or_cnpj(:code, :if => false)
        person.errors.should be_empty
      end

      it ':unless option evaluates true' do
        person = Person.new(:code => '12345678901234')
        person.validates_cpf_or_cnpj(:code, :unless => true)
        person.errors.should be_empty
      end

      it ':on option is :create and the model instance is not a new record' do
        person = Person.new(:code => '12345678901')
        person.stub!(:new_record?, false)
        person.validates_cpf_or_cnpj(:code, :on => :create)
        person.errors.should be_empty
      end

      it ':on option is :update and the model instance is a new record' do
        person = Person.new(:code => '12345678901')
        person.validates_cpf_or_cnpj(:code, :on => :update)
        person.errors.should be_empty
      end
    end
  end
end
