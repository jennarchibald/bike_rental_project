require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/lease')
also_reload('../models/*')

get '/leases' do
  @leases = Lease.all()
  erb(:"lease/index")
end

get '/leases/:id' do
  @lease = Lease.find_by_id(params[:id])
  erb(:'lease/show')
end
