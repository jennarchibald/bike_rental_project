require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/leased_item')
also_reload('../models/*')



get '/leased-items/:lease_id' do
  @lease = Lease.find_by_id(params[:lease_id])
  @items = StockItem.available_items()
  erb(:'leased_items/new')
end


post '/leased-items/:lease_id/delete' do
  LeasedItem.delete_item_from_lease(params['item_id'], params['lease_id'])
  redirect "/leased-items/#{params['lease_id']}"
end

post '/leased-items/:lease_id' do
  leaseditem = LeasedItem.new(params) if params['stock_item_id'] != ""

  if params['stock_id'] != ""
    item = StockItem.find_by_id(params['stock_id'])
    params['stock_item_id'] = params['stock_id']
    if item
      leaseditem = LeasedItem.new(params) if item.available
    end
  end

  leaseditem.save() if leaseditem
  redirect "/leased-items/#{params['lease_id']}"
end
