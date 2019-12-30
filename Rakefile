require_relative "config/environment"
require "sinatra/activerecord/rake"

desc "starts a console"
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

namespace :db do
  desc "seed the database with some dummy data"
  task :seed do
    require_relative "./db/seeds.rb"
  end
end
