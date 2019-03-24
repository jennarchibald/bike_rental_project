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
  @stock_items = StockItem.all()
  erb(:'lease/new')
end

get '/leases/:id' do
  @lease = Lease.find_by_id(params[:id])
  # binding.pry()
  erb(:'lease/show')
end

get '/leases/:id/edit' do
  @customers = Customer.all()
  @stock_items = StockItem.all()
  @lease = Lease.find_by_id(params[:id])
  erb(:'lease/edit')
end


post '/leases' do
  lease = Lease.new(params)
  lease.save()
  redirect '/leases'
end

post '/leases/:id' do
  lease = Lease.new(params)
  lease.update()
  redirect '/leases'
end
