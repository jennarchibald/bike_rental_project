require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/customer')
also_reload('../models/*')

get '/customers' do
  @customers = Customer.all()
  erb(:'customer/index')
end
