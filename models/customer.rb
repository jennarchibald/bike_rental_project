require_relative('../db/sql_runner.rb')
require_relative('./stock_item')

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

  def self.all()
    sql = 'SELECT * FROM customers'
    customers_hashes = SqlRunner.run(sql)
    return customers_hashes.map { |hash| Customer.new(hash)}
  end

  # update

  def update()
    sql = 'UPDATE customers SET (name, contact_number, age) = ($1, $2, $3) WHERE id = $4'
    values = [@name, @contact_number, @age, @id]
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

  # find all the items a customer has leased

  def items_leased()
    sql = 'SELECT stock_items.* FROM stock_items
            INNER JOIN leases
            ON stock_items.id = leases.stock_item_id
            WHERE leases.customer_id = $1'
    values = [@id]
    stock_item_hashes = SqlRunner.run(sql, values)
    return StockItem.map_hashes(stock_item_hashes)
  end

end
