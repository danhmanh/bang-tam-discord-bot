module DB
  database = Sequel.connect("sqlite://demosqlite.sqlite3")

  @@users = database.from(:users)
  @@confessions = database.from(:confessions)

  def self.add_point user
    unless @@users.where(user_id: user.id).any?
      @@users.insert(user_id: user.id, username: user.username, point: 0)
    end

    current_user =  @@users.where(user_id: user.id)
    current_point = current_user.get :point
    current_user.update point: current_point + 100
  end

  def self.get_point user

    current_user = @@users.where(user_id: user.id)
    current_user.get :point
  end

  def self.get_all
    message = "```"
    @@users.order(:point).reverse.each_with_index do |record, index|
      message << "[##{index + 1}] \t #{record[:username]} \t #{record[:point]}p\n"
    end

    message << "```"
  end

  def self.add_confession content
    @@confessions.insert(content: content)
  end

  def self.get_confession id
    cfs = @@confessions.where(id: id)
    message = "```[confession ##{cfs.get(:id)}] #{cfs.get(:content)}\n```"
  end
end
