require 'validates_cpf_cnpj'
require 'active_record'

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
