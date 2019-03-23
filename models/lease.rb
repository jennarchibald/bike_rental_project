require_relative('../db/sql_runner')
require_relative('./customer')

class Lease
  attr_accessor :start_date, :end_date, :customer_id, :stock_item_id
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @start_date = options['start_date']
    @end_date = options['end_date']
    @customer_id = options['customer_id'].to_i
    @stock_item_id = options['stock_item_id'].to_i
  end

  # create

  def save()
    sql = 'INSERT INTO leases (start_date, end_date, customer_id, stock_item_id) VALUES ($1, $2, $3, $4) RETURNING id'
    values = [@start_date, @end_date, @customer_id, @stock_item_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  # read

  def self.all()
    sql = 'SELECT * FROM leases'
    leases_hashes = SqlRunner.run(sql)
    return leases_hashes.map {|hash| Lease.new(hash)}
  end

  # update

  def update()
    sql = 'UPDATE leases SET (start_date, end_date, customer_id, stock_item_id) = ($1, $2, $3, $4) WHERE id = $5'
    values = [@start_date, @end_date, @customer_id, @stock_item_id, @id]
    SqlRunner.run(sql, values)
  end

  # delete

  def delete()
    sql = 'DELETE FROM leases WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM leases"
    SqlRunner.run(sql)
  end

  # return the customer who leased the item

  def customer()
    sql = 'SELECT * FROM customers WHERE id = $1'
    values = [@customer_id]
    customer_hash = SqlRunner.run(sql, values).first
    return Customer.new(customer_hash)
  end

  # return the item which was leased


end
