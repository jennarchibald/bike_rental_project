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
  @customer_id = params['customer_id'].to_i
  p params
  @stock_items = StockItem.available_items()
  erb(:'lease/new')
end

get 'leases/customer/:id/new' do
  @customer = Customer.find_by_id(params[:id])
  erb(:'lease/new')
end

get '/leases/:id' do
  @lease = Lease.find_by_id(params[:id])
  # binding.pry()
  erb(:'lease/show')
end

get '/leases/:id/edit' do
  @customers = Customer.all()
  @lease = Lease.find_by_id(params[:id])
  erb(:'lease/edit')
end


post '/leases' do
  @lease = Lease.new(params)
  @lease.save()
  @items = StockItem.available_items()
  erb(:'leased_items/new')
end

post '/leases/filter' do
  redirect '/leases' if params['filter'] == 'all'
  @leases = Lease.find_by_status(params['filter'])
  erb(:'lease/index')
end


post '/leases/:id' do
  lease = Lease.new(params)
  lease.calculate_total_cost()
  redirect '/leases'
end
