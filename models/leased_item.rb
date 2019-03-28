require("pry")

require_relative('../db/sql_runner')
require_relative('./lease')


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

    lease = Lease.find_by_id(@lease_id)
    lease.calculate_total_cost
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

  # find a leased-item by its id

  def self.find_by_id(id)
    sql = "SELECT * FROM leased_items WHERE id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values).first
    return LeasedItem.new(result)
  end

  # delete an item from a lease using the lease_id and item_id

  def self.delete_item_from_lease(item_id, lease_id)
    sql = "DELETE FROM leased_items WHERE stock_item_id = $1 AND lease_id = $2"
    values = [item_id, lease_id]
    SqlRunner.run(sql, values)

    lease = Lease.find_by_id(lease_id)
    lease.calculate_total_cost()

  end


end
