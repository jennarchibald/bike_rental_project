require_relative('../db/sql_runner')

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
    return ItemType.new(type_hashes)
  end

  # update

  def update()
    sql = 'UPDATE item_types SET (name) = ($1) WHERE id = $2'
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

end
