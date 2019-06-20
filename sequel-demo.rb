require "sequel"
require "pry"
DB = Sequel.connect("sqlite://demosqlite.sqlite3")

users = DB.from(:users)


binding.pry
# users.insert(user_id: 69, point: 10000)
# user =  users.where(user_id: 0)

# current_point = user.get :point

# user.update point: current_point + 100

def add_point user_id, point, users = users
  user =  users.where(user_id: user_id)

  if user.any?
    user = users.insert(user_id: user_id, point: 0)
  end

  current_point = user.get :point
  user.update point: current_point + 100
end

