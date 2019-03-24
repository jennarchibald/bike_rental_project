require('pry')
require_relative('../db/sql_runner')
require_relative('./customer')
require_relative('./stock_item')

class Lease
  attr_accessor :start_date, :duration, :end_date, :customer_id, :stock_item_id, :returned
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    if options['start_date']
      @start_date = Date.parse(options['start_date'])
    else
      @start_date = Date::today
    end
    @duration = options['duration'].to_i
    @end_date = @start_date + @duration
    @customer_id = options['customer_id'].to_i
    @stock_item_id = options['stock_item_id'].to_i
    if options['returned'] == "f"
      @returned = false
    elsif options['returned'] == "t"
      @returned = true
    else
      @returned = false
    end
  end

  # create

  def save()
    sql = 'INSERT INTO leases (start_date, duration, end_date, customer_id, stock_item_id, returned) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id'
    values = [@start_date, @duration, @end_date, @customer_id, @stock_item_id, @returned]
    @id = SqlRunner.run(sql, values).first['id'].to_i


    item = StockItem.find_by_id(@stock_item_id)
    item.mark_unavailable()
  end

  # read

  def self.all()
    sql = 'SELECT * FROM leases'
    leases_hashes = SqlRunner.run(sql)
    return leases_hashes.map {|hash| Lease.new(hash)}
  end

  # return all leases sorted by end date (oldest first)

  def self.all_ordered_by_end_date()
    sql = 'SELECT * FROM leases ORDER BY end_date ASC'
    leases_hashes = SqlRunner.run(sql)
    return leases_hashes.map {|hash| Lease.new(hash)}
  end


  # update

  def update()
    sql = 'UPDATE leases SET (start_date, duration, end_date, customer_id, stock_item_id, returned) = ($1, $2, $3, $4, $5, $6) WHERE id = $7'
    values = [@start_date, @duration, @end_date, @customer_id, @stock_item_id, @returned, @id]
    SqlRunner.run(sql, values)

    if @returned
      item = StockItem.find_by_id(@stock_item_id)
      item.mark_available
    end
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

  # find a lease by id

  def self.find_by_id(id)
    sql = "SELECT * FROM leases WHERE id = $1"
    values = [id]
    lease_hash = SqlRunner.run(sql, values).first
    return Lease.new(lease_hash)
  end

  # return the total cost of a lease

  def total_cost()
    daily_cost = stock_item().rental_cost
    return @duration * daily_cost
  end

  # return the customer who leased the item

  def customer()
    sql = 'SELECT * FROM customers WHERE id = $1'
    values = [@customer_id]
    customer_hash = SqlRunner.run(sql, values).first
    return Customer.new(customer_hash)
  end

  # return the item which was leased

  def stock_item()
    sql = 'SELECT * FROM stock_items WHERE id = $1'
    values = [@stock_item_id]
    stock_item_hash = SqlRunner.run(sql, values).first
    return StockItem.new(stock_item_hash)
  end

  # return true if a lease is overdue (the end_date has passed)

  def overdue?()
    return false if @returned
    check_date = @end_date <=> Date::today
    return check_date < 0
  end

  # mark a lease as returned

  def mark_as_returned()
    @returned = true
    self.update()

    item = StockItem.find_by_id(@stock_item_id)
    binding.pry()
    item.mark_available()
  end

  # map an array of hashes to leases

  def self.map_hashes(array)
    return array.map {|hash| Lease.new(hash)}
  end
end
