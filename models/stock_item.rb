require_relative('../db/sql_runner')
require_relative('./lease')

class StockItem
  attr_accessor :type, :rental_cost, :available
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @type = options['type']
    @rental_cost = options['rental_cost']
    if options['available'] == "f"
      @available = false
    elsif options['available'] == "t"
      @available = true
    else
      @available = true
    end
  end


  # create

  def save()
    sql = 'INSERT INTO stock_items (type, rental_cost, available) VALUES ($1, $2, $3) RETURNING id'
    values = [@type, @rental_cost, @available]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  # read
  # ordered by availibility (available first)
  def self.all()
    sql = 'SELECT * FROM stock_items
            ORDER BY available DESC'
    stock_item_hashes = SqlRunner.run(sql)
    return StockItem.map_hashes(stock_item_hashes)
  end

  # update

  def update()
    sql = 'UPDATE stock_items SET (type, rental_cost, available) = ($1, $2, $3) WHERE id = $4'
    values = [@type, @rental_cost, @available, @id]
    SqlRunner.run(sql, values)
  end


  # delete

  def delete()
    sql = 'DELETE FROM stock_items WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = 'DELETE FROM stock_items'
    SqlRunner.run(sql)
  end


  # find a stock item by its id

  def self.find_by_id(id)
    sql = 'SELECT * FROM stock_items WHERE id = $1'
    values = [id]
    stock_item_hash = SqlRunner.run(sql, values).first
    return StockItem.new(stock_item_hash)
  end

  # find all stock items of a particular type

  def self.find_by_type(type)
    sql = 'SELECT * FROM stock_items WHERE type = $1'
    values = [type]
    stock_item_hashes = SqlRunner.run(sql, values)
    return StockItem.map_hashes(stock_item_hashes)
  end

  # find all current leases for this item

  def current_leases()
    sql = 'SELECT * FROM leases
    WHERE stock_item_id = $1
    AND returned = FALSE
    ORDER BY end_date ASC'
    values = [@id]
    stock_item_hashes = SqlRunner.run(sql, values)
    return Lease.map_hashes(stock_item_hashes)
  end
  # find all past leases for this item

  def past_leases()
    sql = 'SELECT * FROM leases
    WHERE stock_item_id = $1
    AND returned = TRUE
    ORDER BY end_date DESC'
    values = [@id]
    stock_item_hashes = SqlRunner.run(sql, values)
    return Lease.map_hashes(stock_item_hashes)
  end

  # mark an item as unavailable

  def mark_available()
    @available = true
    self.update()
  end

  # mark an item as available

  def mark_unavailable()
    @available = false
    self.update()
  end



  #return all available items
  def self.available_items()
    sql = "SELECT * FROM stock_items
            WHERE available = TRUE"
    items_hashes = SqlRunner.run(sql)
    return StockItem.map_hashes(items_hashes)
  end



  # check if an item is available for rent (not on a lease)
  def available?()
    available_items = StockItem.available_items()
    available_ids = available_items.map {|item| item.id}
    return available_ids.include?(@id)
  end

  #  map an array of hashes into an array of stock items

  def self.map_hashes(array)
    return array.map {|hash| StockItem.new(hash)}
  end


end
