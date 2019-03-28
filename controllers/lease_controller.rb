require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/lease')
also_reload('../models/*')

get '/leases' do
  @leases = Lease.all_ordered_by_end_date()
  @leases = Lease.find_by_status(params['filter']) if params['filter'] && params['filter'] != 'all'
  erb(:"lease/index")
end

get '/leases/new' do
  @customers = Customer.all()
  @customer_id = params['customer_id'].to_i
  p params
  @stock_items = StockItem.available_items()
  erb(:'lease/new')
end

get '/leases/:id' do
  @lease = Lease.find_by_id(params[:id])
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
  redirect "/leased-items/#{@lease.id}"
end


post '/leases/:id' do
  @lease = Lease.new(params)
  @lease.calculate_total_cost()
  redirect "/leased-items/#{@lease.id}"
end
