require_relative('../db/sql_runner.rb')

class Customer
  attr_accessor :name, :contact_number, :age
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @contact_number = options['contact_number']
    @age = options['age'].to_i
  end

  # create
  def save()
    sql = 'INSERT INTO customers (name, contact_number, age) VALUES ($1, $2, $3) RETURNING id'
    values = [@name, @contact_number, @age]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end
  
  # read

  # update

  # delete

end
