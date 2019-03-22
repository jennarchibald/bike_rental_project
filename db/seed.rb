require('pry-byebug')

require_relative('../models/customer')

Customer.delete_all

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



binding.pry()
nil
