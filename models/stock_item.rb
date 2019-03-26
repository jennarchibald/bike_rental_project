require_relative('../db/sql_runner')
require_relative('./lease')
require_relative('./item_type')

class StockItem
  attr_accessor :type_id, :rental_cost, :available
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @type_id = options['type_id'].to_i
    @rental_cost = options['rental_cost']
    if options['available'] == "f" || options['available'] == 'false'
      @available = false
    elsif options['available'] == "t" || options['available'] == 'true'
      @available = true
    else
      @available = true
    end
  end


  # create

  def save()
    sql = 'INSERT INTO stock_items (type_id, rental_cost, available) VALUES ($1, $2, $3) RETURNING id'
    values = [@type_id, @rental_cost, @available]
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
    sql = 'UPDATE stock_items SET (type_id, rental_cost, available) = ($1, $2, $3) WHERE id = $4'
    values = [@type_id, @rental_cost, @available, @id]
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
    sql = 'SELECT stock_items.* FROM stock_items
            INNER JOIN item_types
            ON stock_items.type_id = item_types.id
            WHERE item_types.name = $1'
    values = [type]
    stock_item_hashes = SqlRunner.run(sql, values)
    return StockItem.map_hashes(stock_item_hashes)
  end

  # find all current leases for this item

  def current_leases()
    sql = 'SELECT leases.* FROM leases
    INNER JOIN leased_items
    ON leases.id = leased_items.lease_id
    WHERE leased_items.stock_item_id = $1
    AND returned = FALSE
    ORDER BY end_date ASC'
    values = [@id]
    stock_item_hashes = SqlRunner.run(sql, values)
    return Lease.map_hashes(stock_item_hashes)
  end
  # find all past leases for this item

  def past_leases()
    sql = 'SELECT leases.* FROM leases
    INNER JOIN leased_items
    ON leases.id = leased_items.lease_id
    WHERE leased_items.stock_item_id = $1
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

  # return the name of the item type

  def type()
    sql = 'SELECT name FROM item_types WHERE id = $1'
    values = [@type_id]
    result = SqlRunner.run(sql, values).first['name']
    return result
  end

  #  map an array of hashes into an array of stock items

  def self.map_hashes(array)
    return array.map {|hash| StockItem.new(hash)}
  end


end
