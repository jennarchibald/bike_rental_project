require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/item_type')
also_reload('../models/*')
