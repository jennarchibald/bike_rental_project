require('minitest/autorun')
require('minitest/rg')

require_relative('../models/stock_item')

class StockItemTest < MiniTest::Test

  def setup()

    @stock_item1 = StockItem.new({
      'type' => 'bike',
      'rental_cost' => '9.50'
      })

  end

  def test_item_can_be_available()
    assert_equal(@stock_item1.available, true)
    @stock_item1.mark_unavailable
    assert_equal(@stock_item1.available, false)
    @stock_item1.mark_available
    assert_equal(@stock_item1.available, true)
  end
end
