require('pry')
require_relative('../db/sql_runner')
require_relative('./customer')
require_relative('./stock_item')

class Lease
  attr_accessor :start_date, :duration, :end_date, :customer_id,  :returned, :total_cost
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

    if options['returned'] == "f"
      @returned = false
    elsif options['returned'] == "t"
      @returned = true
    else
      @returned = false
    end

    @total_cost = options['total_cost']

  end

  # create

  def save()
    sql = 'INSERT INTO leases (start_date, duration, end_date, customer_id, returned, total_cost) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id'
    values = [@start_date, @duration, @end_date, @customer_id,  @returned, @total_cost]
    @id = SqlRunner.run(sql, values).first['id'].to_i


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
    sql = 'UPDATE leases SET (start_date, duration, end_date, customer_id, returned, total_cost) = ($1, $2, $3, $4, $5, $6) WHERE id = $7'
    values = [@start_date, @duration, @end_date, @customer_id, @returned, @total_cost, @id]
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

  # find a lease by id

  def self.find_by_id(id)
    sql = "SELECT * FROM leases WHERE id = $1"
    values = [id]
    lease_hash = SqlRunner.run(sql, values).first
    return Lease.new(lease_hash)
  end

  # return the total cost of a lease

  def calculate_total_cost()
    items = self.stock_items()
    if items.length == 0
      @total_cost = 0
    else
      daily_cost = items.reduce(0) {|sum, item| sum += item.rental_cost.to_f}
      @total_cost = @duration * daily_cost
    end
    self.update()
  end

  # return the daily cost of a lease as a string

  def daily_cost()
    cost = @total_cost.to_f / @duration.to_f
    return cost.to_s + "0"
  end

  # return the total fine for an overdue lease (daily cost * days overdue)
  # as a string

  def total_fine()
    fine = daily_cost().to_f * days_overdue().to_f
    return fine.to_s + "0"
  end

  # return the customer who leased the item

  def customer()
    sql = 'SELECT * FROM customers WHERE id = $1'
    values = [@customer_id]
    customer_hash = SqlRunner.run(sql, values).first
    return Customer.new(customer_hash)
  end

  # return the items which were leased

  def stock_items()
    sql = "SELECT stock_items.* FROM stock_items
            INNER JOIN leased_items
            ON stock_items.id = leased_items.stock_item_id
            WHERE leased_items.lease_id = $1"
    values = [@id]
    stock_item_hashes = SqlRunner.run(sql, values)
    return stock_item_hashes.map {|hash| StockItem.new(hash)}
  end


  # return true if a lease is overdue (the end_date has passed)

  def overdue?()
    return false if @returned
    check_date = @end_date <=> Date::today
    return check_date < 0
  end

  # calculate the days overdue a lease is

  def days_overdue
    difference = @end_date - Date::today
    days_difference = difference.to_i
    return days_difference * -1
  end


  # find all leases of a certain status - active, past, returned

  def self.find_by_status(status)
    case status
    when 'active'
      return Lease.all_current()
    when 'past'
      return Lease.all_past()
    when 'overdue'
      return Lease.all_overdue()
    end
  end


  # find all active leases (returned is false)
  def self.all_current()
    leases = Lease.all_ordered_by_end_date()
    current_leases = []
    leases.each {|lease| current_leases.push(lease) if lease.returned == false}
    return current_leases
  end

  # find all past leases (returned is true)
  def self.all_past()
    leases = Lease.all_ordered_by_end_date()
    past_leases = []
    leases.each {|lease| past_leases.push(lease) if lease.returned}
    return past_leases
  end

  # find all overdue leases

  def self.all_overdue()
    leases = Lease.all_ordered_by_end_date()
    overdue_leases = []
    leases.each {|lease| overdue_leases.push(lease) if lease.overdue?}
    return overdue_leases
  end

  # map an array of hashes to leases

  def self.map_hashes(array)
    return array.map {|hash| Lease.new(hash)}
  end
end
