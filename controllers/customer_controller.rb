require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/customer')
also_reload('../models/*')

get '/customers' do
  @customers = Customer.all()
  @customers = Customer.search_by_name(params['name']) if params['name']
  erb(:'customer/index')
end

get '/customers/new' do
  erb(:'customer/new')
end

get '/customers/:id' do
  @customer = Customer.find_by_id(params[:id])
  erb(:'customer/show')
end

get '/customers/:id/edit' do
  @customer = Customer.find_by_id(params[:id])
  erb(:'customer/edit')
end

get '/customers/:id/delete' do
  @customer = Customer.find_by_id(params[:id])
  erb(:'customer/delete')
end



post '/customers' do
  new_customer = Customer.new(params)
  new_customer.save()
  redirect '/customers'
end

post '/customers/search' do
  @customers = Customer.search_by_name(params['name'])
  erb(:'customer/index')
end

post '/customers/:id' do
  customer = Customer.new(params)
  customer.update()
  redirect '/customers'
end

post '/customers/:id/delete' do
  customer = Customer.find_by_id(params[:id])
  customer.delete
  redirect '/customers'
end
