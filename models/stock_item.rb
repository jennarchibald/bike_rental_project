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

  # update

  # delete
end
