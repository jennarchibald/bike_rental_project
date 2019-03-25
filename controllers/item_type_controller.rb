require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/item_type')
also_reload('../models/*')

get '/item-types' do
  @types = ItemType.all()
  erb(:'item_types/index')
end

get '/item-types/:id/edit' do
  @type = ItemType.find_by_id(params[:id])
  erb(:'item_types/edit')
end

post '/item-types/:id' do
  type = ItemType.new(params)
  type.update()
  redirect '/item-types'
end
