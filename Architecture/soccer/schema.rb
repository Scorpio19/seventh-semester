ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'
    create_table :users do |table|
      table.column :username, :string
      table.column :password, :string
      table.column :admin, :boolean
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'polls'
    create_table :polls do |table|
      table.column :status, :string
      table.column :matches, :string
      table.column :results, :string
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'picks'
    create_table :picks do |table|
      table.column :user_id, :integer
      table.column :poll_id, :integer
      table.column :score, :integer
      table.column :expected, :string
    end
  end
end
