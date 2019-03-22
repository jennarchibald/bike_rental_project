require('sinatra')
require('sinatra/contrib/all')

require_relative('./models/customer')
require_relative('./models/lease')
require_relative('./models/stock_item')

also_reload('./models/*')


get '/' do
  erb(:home)
end
