require_relative('../db/sql_runner')

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
    return stock_item_hashes.map { |hash| StockItem.new(hash)}
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
    return stock_item_hashes.map {|hash| StockItem.new(hash)}
  end

end
