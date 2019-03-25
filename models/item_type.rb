require('pry')
require_relative('../db/sql_runner')
require_relative('./stock_item')

class ItemType
  attr_reader :id
  attr_accessor :name
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  # create
  def save()
    sql = 'INSERT INTO item_types (name) VALUES ($1) RETURNING id'
    values = [@name]
    @id = SqlRunner.run(sql, values).first['id']
  end

  # read

  def self.all()
    sql = 'SELECT * FROM item_types'
    type_hashes = SqlRunner.run(sql)
    # binding.pry()
    return type_hashes.map {|hash| ItemType.new(hash)}
  end

  # update

  def update()
    sql = 'UPDATE item_types SET name = $1 WHERE id = $2'
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  # delete

  def delete()
    sql = 'DELETE FROM item_types WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = 'DELETE FROM item_types'
    SqlRunner.run(sql)
  end

  # find a specific item type by id

  def self.find_by_id(id)
    sql = 'SELECT * FROM item_types WHERE id = $1'
    values = [id]
    result = SqlRunner.run(sql, values).first
    return ItemType.new(result)
  end

  # return all the stock items of this type

  def all_items()
    sql = "SELECT * FROM stock_items WHERE type_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return StockItem.map_hashes(result)
  end

end
