require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/stock_item')
also_reload('../models/*')


get '/stock' do
  @stock_items = StockItem.all()
  erb(:"stock/index")
end

get '/stock/new' do
  erb(:'stock/new')
end


get '/stock/:id' do
  @stock_item = StockItem.find_by_id(params[:id])
  erb(:'stock/show')
end


post '/stock' do
  item = StockItem.new(params)
  item.save()
  redirect '/stock'
end
