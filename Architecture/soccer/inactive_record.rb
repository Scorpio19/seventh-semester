DATA_BASE = SQLite3::Database.new('soccer.db')

class InActiveRecord
  def self.has_many(name)
    define_method name do
      other = Kernel.const_get(name.to_s.capitalize)
      field = self.class.name.to_s.downcase
      field = field[0, field.size - 1] +  "_id"
      other.find({field.to_sym => @id})
    end
  end
  
  def self.belongs_to(name, var)
    define_method name do
      other = Kernel.const_get(name.to_s.capitalize)
      other.find({id: eval("@#{var}")})[0]
    end
  end

  def self.has_one(name, var)
    belongs_to(name, var)
  end


  def self.create_from_results(results)
    nil
  end

  def self.parse_params(params)
    query = ""
    values = Array.new
    params.each do |k, v|
      if query.empty?
        query += "#{k.to_s} = ?"
      else
        query += " and #{k.to_s} = ?"
      end
      values << v
    end
    [query, values]
  end

  def self.find(params)
    query, values = parse_params(params)
    query = "select * from #{self} where " + query
    results = DATA_BASE.execute(query, values)
    create_from_results(results)
  end

  def parse_columns
    query = ""
    values = Array.new
    (self.methods - InActiveRecord.methods).each do |v|
      variable_name = v.to_s
      if variable_name.count('=') <= 0
        next
      end

      variable_name.tr! '=', ''

      if query.empty?
        query += "#{variable_name} = ?"
      else
        query += ", #{variable_name} = ?"
      end
      values << send(variable_name).to_s
    end
    [query, values]
  end

  def save
    query, values = parse_columns
    values << Time.now.to_s
    query += ", updated_at = ?"
    if @id
      values << @id
      DATA_BASE.execute("update #{self.class} set #{query} where id=?", values)
    else
      values << Time.now.to_s
      query = "id, #{query}, created_at"
      @id = DATA_BASE.get_first_row("select max(id) from #{self.class}")[0] + 1
      values.unshift(@id)
      query.tr!(' = ?', '')
      placeholders = "?, " * (values.size - 1)
      placeholders += "?"
      DATA_BASE.execute("insert into #{self.class} (#{query}) values (#{placeholders})", values) 
    end
  end

  def self.create(params)
    new_instance = self.new(params)
    new_instance.save
    new_instance
  end

  def self.all
    results = DATA_BASE.execute("select * from #{self}")
    create_from_results(results)
  end
end

require_relative 'models/user'
require_relative 'models/poll'
require_relative 'models/pick'
