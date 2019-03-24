require('sinatra')
require('sinatra/contrib/all')

require_relative('controllers/stock_controller')
require_relative('controllers/customer_controller')
require_relative('controllers/lease_controller')

also_reload('./models/*')

get '/' do
  erb(:index)
end
