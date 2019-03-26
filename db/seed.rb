require('pry-byebug')

require_relative('../models/customer')
require_relative('../models/stock_item')
require_relative('../models/lease')
require_relative('../models/leased_item')

Customer.delete_all()
StockItem.delete_all()
ItemType.delete_all()


# CUSTOMERS
customer1 = Customer.new({
  'first_name' => 'Jenn',
  'last_name' => 'Archibald',
  'contact_number' => '08999112334',
  'age' => '27'
  })

customer1.save()

customer2 = Customer.new({
  'first_name' => 'Alex',
  'last_name' => 'Archibald',
  'contact_number' => '08999223445',
  'age' => '56'
  })

customer2.save()

customer3 = Customer.new({
  'first_name' => 'Alex',
  'last_name' => 'Jones',
  'contact_number' => '08999223345',
  'age' => '16'
  })

customer3.save()

customer4 = Customer.new({
  'first_name' => 'Ben',
  'last_name' => 'Smith',
  'contact_number' => '08979223345',
  'age' => '26'
  })

customer4.save()

customer5 = Customer.new({
  'first_name' => 'Adam',
  'last_name' => 'Black',
  'contact_number' => '08979223344',
  'age' => '29'
  })

customer5.save()

#  ITEM TYPES

type1 = ItemType.new({
  'name' => 'bike'
  })

type1.save()

type2 = ItemType.new({
  'name' => 'helmet'
  })

type2.save()

type3 = ItemType.new({
  'name' => 'lock'
  })

type3.save()



# STOCK

item1 = StockItem.new({
  'type_id' => type1.id,
  'rental_cost' => '9.50'
  })

item1.save()

item2 = StockItem.new({
  'type_id' => type1.id,
  'rental_cost' => '9.50'
  })

item2.save()

item3 = StockItem.new({
  'type_id' => type1.id,
  'rental_cost' => '9.50'
  })

item3.save()

item4 = StockItem.new({
  'type_id' => type2.id,
  'rental_cost' => '0.50'
  })

item4.save()

item5 = StockItem.new({
  'type_id' => type2.id,
  'rental_cost' => '0.50'
  })

item5.save()

item6 = StockItem.new({
  'type_id' => type3.id,
  'rental_cost' => '4.50'
  })

item6.save()

item7 = StockItem.new({
  'type_id' => type3.id,
  'rental_cost' => '4.50'
  })

item7.save()

item8 = StockItem.new({
  'type_id' => type1.id,
  'rental_cost' => '9.50'
  })

item8.save()


# LEASES

lease1 = Lease.new({
  'duration' => '7',
  'customer_id' => customer1.id,
  })

lease1.save()

leased_item1 = LeasedItem.new({
  'lease_id' => lease1.id,
  'stock_item_id' => item1.id
  })

leased_item1.save()

leased_item2 = LeasedItem.new({
  'lease_id' => lease1.id,
  'stock_item_id' => item2.id
  })

leased_item2.save()

# lease2 = Lease.new({
#   'duration' => '3',
#   'customer_id' => customer2.id,
#   'stock_item_id' => item2.id
#   })
#
# lease2.save()
#
# lease3 = Lease.new({
#   'duration' => '7',
#   'customer_id' => customer1.id,
#   'stock_item_id' => item4.id
#   })
#
# lease3.save()
#
# lease4 = Lease.new({
#   'start_date' => '2019-03-14',
#   'duration' => '7',
#   'customer_id' => customer2.id,
#   'stock_item_id' => item5.id
#   })
#
# lease4.save()
#
# lease5 = Lease.new({
#   'start_date' => '2019-03-14',
#   'duration' => '7',
#   'customer_id' => customer3.id,
#   'stock_item_id' => item7.id
#   })
#
# lease5.save()
#
# lease6 = Lease.new({
#   'duration' => '7',
#   'customer_id' => customer5.id,
#   'stock_item_id' => item8.id
#   })
#
# lease6.save()




binding.pry()
nil
