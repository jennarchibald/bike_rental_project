require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/leased_item')
also_reload('../models/*')

post '/leased-items' do
  @items = StockItem.available_items()
  @lease = Lease.find_by_id(params['lease_id'])
  erb(:'leased_items/new')
end

post '/leased-items/:id' do
  leaseditem = LeasedItem.new(params)
  leaseditem.save()
  @items = StockItem.available_items()
  @lease = Lease.find_by_id(params[:id])
  erb(:'leased_items/new')
end
