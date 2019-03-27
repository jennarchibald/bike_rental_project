require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/stock_item')
also_reload('../models/*')


get '/stock' do
  @stock_items = StockItem.all()
  @stock_items = StockItem.find_by_type(params['type']) if params['type'] && params['type'] != 'all'
  @stock_items = [StockItem.find_by_id(params['id'])] if params['id']
  @item_types = ItemType.all()
  erb(:"stock/index")
end

get '/stock/new' do
  @types = ItemType.all()
  erb(:'stock/new')
end

get '/stock/:id' do
  @stock_item = StockItem.find_by_id(params[:id])
  erb(:'stock/show')
end

get '/stock/:id/edit' do
  @types = ItemType.all()
  @stock_item = StockItem.find_by_id(params[:id])
  erb(:'stock/edit')
end

get '/stock/:id/delete' do
  @stock_item = StockItem.find_by_id(params[:id])
  erb(:'stock/delete')
end


post '/stock' do
  item = StockItem.new(params)
  item.save()
  redirect '/stock'
end


post '/stock/:id' do
  item = StockItem.new(params)
  item.update()
  redirect '/stock'
end

post '/stock/:id/delete' do
  item = StockItem.find_by_id(params[:id])
  item.delete()
  redirect '/stock'
end
