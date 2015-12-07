require 'validates_cpf_cnpj'
require 'active_record'

I18n.enforce_available_locales = false

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :people do |t|
    t.string :code
  end
end

class Person < ActiveRecord::Base
end
