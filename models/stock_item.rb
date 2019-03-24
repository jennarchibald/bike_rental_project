require_relative('../db/sql_runner')
require_relative('./lease')

class StockItem
  attr_accessor :type, :rental_cost
  attr_reader :id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @type = options['type']
    @rental_cost = options['rental_cost'].to_f
  end


  # create

  def save()
    sql = 'INSERT INTO stock_items (type, rental_cost) VALUES ($1, $2) RETURNING id'
    values = [@type, @rental_cost]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  # read

  def self.all()
    sql = 'SELECT * FROM stock_items'
    stock_item_hashes = SqlRunner.run(sql)
    return StockItem.map_hashes(stock_item_hashes)
  end

  # update

  def update()
    sql = 'UPDATE stock_items SET (type, rental_cost) = ($1, $2) WHERE id = $3'
    values = [@type, @rental_cost, @id]
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

  #  map an array of hashes into an array of stock items

  def self.map_hashes(array)
    return array.map {|hash| StockItem.new(hash)}
  end


end
