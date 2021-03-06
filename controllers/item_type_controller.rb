require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/item_type')
also_reload('../models/*')

get '/item-types' do
  @types = ItemType.all()
  erb(:'item_types/index')
end

get '/item-types/new' do
  erb(:'item_types/new')
end

get '/item-types/:id' do
  @type = ItemType.find_by_id(params[:id])
  erb(:'item_types/show')
end

get '/item-types/:id/delete' do
  @type = ItemType.find_by_id(params[:id])
  erb(:'item_types/delete')
end

get '/item-types/:id/edit' do
  @type = ItemType.find_by_id(params[:id])
  erb(:'item_types/edit')
end


post '/item-types' do
  item = ItemType.new(params)
  item.save()
  redirect "/item-types/#{item.id}"
end

post '/item-types/:id' do
  @type = ItemType.new(params)
  @type.update()
  redirect "/item-types/#{@type.id}"
end

post '/item-types/:id/delete' do
  type = ItemType.find_by_id(params[:id])
  type.delete()
  redirect '/item-types'
end
