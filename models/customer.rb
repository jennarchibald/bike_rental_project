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

  def self.all
    sql = 'SELECT * FROM customers'
    customers_hashes = SqlRunner.run(sql)
    return customers_hashes.map { |hash| Customer.new(hash)}
  end

  # update

  # delete

  def delete()
    sql = 'DELETE FROM customers WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = 'DELETE FROM customers'
    SqlRunner.run(sql)
  end

end
