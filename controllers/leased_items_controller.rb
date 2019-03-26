require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/leased_item')
also_reload('../models/*')

get '/leased-items/new' do
  erb(:'leased_items/new')
end
