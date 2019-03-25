require('minitest/autorun')
require('minitest/rg')

require_relative('../models/customer')
require_relative('../models/stock_item')
require_relative('../models/lease')

class LeaseTest < MiniTest::Test

  def setup

    @customer1 = Customer.new({
      'first_name' => 'Jenn',
      'last_name' => 'Archibald',
      'contact_number' => '08999112334',
      'age' => '27'
      })

    @customer1.save()

    @item1 = StockItem.new({
      'type' => 'bike',
      'rental_cost' => '9.50'
      })

    @item1.save()

    @lease1 = Lease.new({
      'duration' => '7',
      'customer_id' => @customer1.id,
      'stock_item_id' => @item1.id
      })

    @lease1.save()

    @lease2 = Lease.new({
      'start_date' => '2019-01-01',
      'duration' => '7',
      'customer_id' => @customer1.id,
      'stock_item_id' => @item1.id
      })

    @lease2.save()
  end

  def test_lease_has_total_cost()
    result = @lease1.total_cost()
    assert_equal(66.5, result)
  end

  def test_lease_can_be_overdue()
    assert_equal(@lease2.overdue?, true)
    assert_equal(@lease1.overdue?, false)
  end

end
