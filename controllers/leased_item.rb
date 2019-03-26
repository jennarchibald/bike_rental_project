require_relative('../db/sql_runner')


class LeasedItem
  attr_reader :id
  attr_accessor :lease_id, :stock_item_id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @lease_id = options['lease_id'].to_i
    @stock_item_id = options['stock_item_id'].to_i
  end


  # create

  def save()
    sql = "INSERT INTO leased_items (lease_id, stock_item_id) VALUES ($1, $2) RETURNING id"
    values = [@lease_id, @stock_item_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  # read

  def   self.all()
    sql = "SELECT * FROM leased_items"
    result = SqlRunner.run(sql)
    return result.map {|hash| LeasedItem.new(hash)}
  end


  # update

  def update()
    sql = "UPDATE leased_items SET (lease_id, stock_item_id) = ($1, $2) WHERE id = $3"
    values = [@lease_id, @stock_item_id, @id]
    SqlRunner.run(sql, values)
  end



  # delete

  def delete()
    sql = "DELETE FROM leased_items WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM leased_items"
    SqlRunner.run(sql)
  end





end
