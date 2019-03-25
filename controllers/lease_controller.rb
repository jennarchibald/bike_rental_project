require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/lease')
also_reload('../models/*')

get '/leases' do
  @leases = Lease.all_ordered_by_end_date()
  erb(:"lease/index")
end

get '/leases/new' do
  @customers = Customer.all()
  @stock_items = StockItem.available_items()
  erb(:'lease/new')
end

get '/leases/:id' do
  @lease = Lease.find_by_id(params[:id])
  # binding.pry()
  erb(:'lease/show')
end

get '/leases/:id/edit' do
  @customers = Customer.all()
  @stock_items = StockItem.available_items()
  @lease = Lease.find_by_id(params[:id])
  @stock_items.push(StockItem.find_by_id(@lease.stock_item_id))
  erb(:'lease/edit')
end


post '/leases' do
  lease = Lease.new(params)
  lease.save()
  redirect '/leases'
end

post '/leases/filter' do
  redirect '/leases' if params['filter'] == 'all'
  @leases = Lease.find_by_status(params['filter'])
  erb(:'lease/index')
end

post '/leases/:id' do
  # binding.pry()
  lease = Lease.new(params)
  lease.update()
  redirect '/leases'
end
