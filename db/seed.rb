require('pry-byebug')

require_relative('../models/customer')
require_relative('../models/stock_item')
require_relative('../models/lease')

Customer.delete_all()
StockItem.delete_all()


# CUSTOMERS
customer1 = Customer.new({
  'name' => 'Jenn',
  'contact_number' => '08999112334',
  'age' => '27'
  })

customer1.save()

customer2 = Customer.new({
  'name' => 'Alex',
  'contact_number' => '08999223445',
  'age' => '56'
  })

customer2.save()




# STOCK

item1 = StockItem.new({
  'type' => 'bike',
  'rental_cost' => '9.50'
  })

item1.save()

item2 = StockItem.new({
  'type' => 'bike',
  'rental_cost' => '9.50'
  })

item2.save()

item3 = StockItem.new({
  'type' => 'bike',
  'rental_cost' => '9.50'
  })

item3.save()

item4 = StockItem.new({
  'type' => 'helmet',
  'rental_cost' => '0.50'
  })

item4.save()

item5 = StockItem.new({
  'type' => 'helmet',
  'rental_cost' => '0.50'
  })

item5.save()

item6 = StockItem.new({
  'type' => 'lock',
  'rental_cost' => '4.50'
  })

item6.save()


# LEASES

lease1 = Lease.new({
  'duration' => '7',
  'customer_id' => customer1.id,
  'stock_item_id' => item1.id
  })

lease1.save()

lease2 = Lease.new({
  'duration' => '3',
  'customer_id' => customer2.id,
  'stock_item_id' => item2.id
  })

lease2.save()

lease3 = Lease.new({
  'duration' => '7',
  'customer_id' => customer1.id,
  'stock_item_id' => item4.id
  })

lease3.save()

lease4 = Lease.new({
  'duration' => '-7',
  'customer_id' => customer2.id,
  'stock_item_id' => item5.id
  })

lease4.save()

lease1.returned()


binding.pry()
nil
