require_relative('../db/sql_runner')
require_relative('./lease')
require_relative('./item_type')

class StockItem
  attr_accessor :type_id, :rental_cost
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @type_id = options['type_id'].to_i
    @rental_cost = options['rental_cost']
  end


  # create

  def save()
    sql = 'INSERT INTO stock_items (type_id, rental_cost) VALUES ($1, $2) RETURNING id'
    values = [@type_id, @rental_cost]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  # read
  def self.all()
    sql = 'SELECT * FROM stock_items'
    stock_item_hashes = SqlRunner.run(sql)
    items = StockItem.map_hashes(stock_item_hashes)
    items.sort_by {|item| item.available.to_s}
    return items.reverse
  end

  # update

  def update()
    sql = 'UPDATE stock_items SET (type_id, rental_cost) = ($1, $2) WHERE id = $3'
    values = [@type_id, @rental_cost, @id]
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
    return StockItem.new(stock_item_hash) if stock_item_hash
    return stock_item_hash
  end

  # find all stock items of a particular type

  def self.find_by_type(type)
    sql = 'SELECT stock_items.* FROM stock_items
    INNER JOIN item_types
    ON stock_items.type_id = item_types.id
    WHERE item_types.name = $1'
    values = [type]
    stock_item_hashes = SqlRunner.run(sql, values)
    items =  StockItem.map_hashes(stock_item_hashes)
    items.sort_by {|item| item.available.to_s}
    return items.reverse

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

  # return t/f if an item is available
  # items are unavailable when they are leased and have not yet been returned

  def available()
    sql = 'SELECT stock_items.* FROM stock_items
    INNER JOIN leased_items
    ON leased_items.stock_item_id = stock_items.id
    INNER JOIN leases
    ON leases.id = leased_items.lease_id
    WHERE leases.returned = false'
    all_unavailable_hashes = SqlRunner.run(sql)
    all_unavailable = StockItem.map_hashes(all_unavailable_hashes)

    unavailable_ids = all_unavailable.map {|item| item.id}
    if unavailable_ids.include?(@id)
      return false
    else
      return true
    end
  end



  # return all available items
  def self.available_items()
    items = self.all()
    available_items = []
    items.each {|item| available_items.push(item) if item.available}
    return available_items
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
