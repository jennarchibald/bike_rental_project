require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/customer')
also_reload('../models/*')

get '/customers' do
  @customers = Customer.all()
  erb(:'customer/index')
end

get '/customers/new' do
  erb(:'customer/new')
end

get '/customers/:id' do
  @customer = Customer.find_by_id(params[:id])
  erb(:'customer/show')
end



post '/customers' do
  new_customer = Customer.new(params)
  new_customer.save()
  redirect '/customers'
end
