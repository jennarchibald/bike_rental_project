require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/leased_item')
also_reload('../models/*')

get '/leased-items' do
  @lease = Lease.find_by_id(params['lease_id'])
  @items = StockItem.available_items()
  erb(:'leased_items/new')
end


post '/leased-items/:lease_id/delete' do
  LeasedItem.delete_item_from_lease(params['item_id'], params['lease_id'])
  # binding.pry()
  @lease = Lease.find_by_id(params[:lease_id])
  @items = StockItem.available_items()
  erb(:'leased_items/new')
end

post '/leased-items/:lease_id' do
  leaseditem = LeasedItem.new(params)
  leaseditem.save()
  @items = StockItem.available_items()
  @lease = Lease.find_by_id(params[:lease_id])
  erb(:'leased_items/new')
end
