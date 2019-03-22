require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/stock_item')
also_reload('../models/*')


get '/stock' do
  @stock_items = StockItem.all()
  erb(:"stock/index")
end
