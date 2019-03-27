require_relative('../db/sql_runner.rb')
require_relative('./stock_item')
require_relative('./lease')

class Customer
  attr_accessor :first_name, :last_name, :contact_number, :age
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
    @contact_number = options['contact_number']
    @age = options['age'].to_i
  end

  # create
  def save()
    sql = 'INSERT INTO customers (first_name, last_name, contact_number, age) VALUES ($1, $2, $3, $4) RETURNING id'
    values = [@first_name, @last_name, @contact_number, @age]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  # read

  def self.all()
    sql = 'SELECT * FROM customers'
    customers_hashes = SqlRunner.run(sql)
    return customers_hashes.map { |hash| Customer.new(hash)}
  end

  # update

  def update()
    sql = 'UPDATE customers SET (first_name, last_name, contact_number, age) = ($1, $2, $3, $4) WHERE id = $5'
    values = [@first_name, @last_name, @contact_number, @age, @id]
    SqlRunner.run(sql, values)
  end

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

  # find a customer by their id

  def self.find_by_id(id)
    sql = 'SELECT * FROM customers WHERE id = $1'
    values = [id]
    customer_hash = SqlRunner.run(sql, values).first
    return Customer.new(customer_hash)
  end

  # search for a customer by name

  def self.search_by_name(name)
    string_array = name.split(' ')
    customers = []
    for string in string_array

    sql = "SELECT * FROM customers
            WHERE LOWER(first_name) LIKE $1
            OR LOWER(last_name) LIKE $1"
    values = ["%" + string.downcase + "%"]
    customers_hashes = SqlRunner.run(sql, values)
    customers << customers_hashes.map {|hash| Customer.new(hash)}
    end
    customers = customers.flatten.uniq {|customer| customer.id}
  end


  # find all the current leases (not returned)
  def current_leases()
    sql = 'SELECT * FROM leases
            WHERE customer_id = $1
            AND returned = FALSE
            ORDER BY end_date ASC'
    values = [@id]
    stock_item_hashes = SqlRunner.run(sql, values)
    return Lease.map_hashes(stock_item_hashes)
  end

  # find all the past leases (returned)
  def past_leases()
    sql = 'SELECT * FROM leases
            WHERE customer_id = $1
            AND returned = TRUE
            ORDER BY end_date DESC'
    values = [@id]
    stock_item_hashes = SqlRunner.run(sql, values)
    return Lease.map_hashes(stock_item_hashes)
  end
end
