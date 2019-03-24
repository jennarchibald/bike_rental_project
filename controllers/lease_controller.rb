require('pry')
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/lease')
also_reload('../models/*')

get '/leases' do
  @leases = Lease.all_ordered_by_end_date()
  erb(:"lease/index")
end

get '/leases/:id' do
  @lease = Lease.find_by_id(params[:id])
  # binding.pry()
  erb(:'lease/show')
end
