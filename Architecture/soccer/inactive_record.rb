# Final Project: Soccer Polls
# Date: 23-Nov-2015
# Authors:
#   A01370815   Diego Galindez Barreda
#   A01169999   Rodrigo Villalobos Sanchez
#   A01165957   Saul de Nova Caballero

# Reference to the database connection.
# This is used by all the classes that
# inherit from InActiveRecord
DATA_BASE = SQLite3::Database.new('soccer.db')

# The +InActiveRecord+ class handles all the operations
# that the models have to implement so they can communicate
# with the database.
# Models that inherit from it must implement the 
# InActiveRecord::create_from_results for proper usage.
class InActiveRecord

  # Creates a new many-to-one relation, where the
  # calling model is the One and the passed name refers
  # to the model of which it has many instances.
  #
  # Parameters::
  #   name:: The model to which the relation must be made.
  #          It needs to be the same as the class name.
  def self.has_many(name)
    define_method name do
      other = Kernel.const_get(name.to_s.capitalize)
      field = self.class.name.to_s.downcase
      field = field[0, field.size - 1] +  "_id"
      other.find({field.to_sym => @id})
    end
  end
  
  # Creates a new one-to-many relation, where the
  # calling model is the Many and the passed name refers
  # to the model of which it has an instance.
  #
  # Parameters::
  #   name:: The model to which the relation must be made.
  #          It needs to be the same as the class name.
  def self.belongs_to(name, var)
    define_method name do
      other = Kernel.const_get(name.to_s.capitalize)
      other.find({id: eval("@#{var}")})[0]
    end
  end

  # Creates a new one-to-many relation, where the
  # calling model is the Many and the passed name refers
  # to the model of which it has an instance.
  # There is no difference between InActiveRecord::belongs_to
  # and this, it is only for readability and semantics.
  #
  # Parameters::
  #   name:: The model to which the relation must be made.
  #          It needs to be the same as the class name.
  def self.has_one(name, var)
    belongs_to(name, var)
  end

  # "Virtual" method that must be implemented by any class
  # that inherits from InActiveRecord. It should take an
  # array following the table's structure and parse it into
  # a set of objects of the type they should be.
  #
  # Parameters::
  #   results:: The array with the Database's response.
  #
  # Returns:: nil . Proper implementation must be made in
  #           each class that inherits.
  def self.create_from_results(results)
    nil
  end

  # Parses the hash given into a query and an array of
  # values the query refers to.
  #
  # Parameters::
  #   params:: A hash relating the name of a field to
  #            the value it should be given.
  #
  # Returns:: An array containing the query string as 
  #           first element and the values array as a
  #           second element.
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

  # Uses the given hash to find an element in the current
  # table, with the restrictions set in the hash.
  # It also calls the adequate method to create the
  # instances from the results.
  #
  # Parameters::
  #   params:: A hash relating the name of a field to
  #            the restriction or condition to find.
  def self.find(params)
    query, values = parse_params(params)
    query = "select * from #{self} where " + query
    results = DATA_BASE.execute(query, values)
    create_from_results(results)
  end

  # Creates a new row in the database and a new
  # instance of the required model, with the given
  # hash.
  #
  # Parameters::
  #   params:: A hash relating the name of a field to
  #            the value it should be given.
  #
  # Returns:: The new instance.
  def self.create(params)
    new_instance = self.new(params)
    new_instance.save
    new_instance
  end

  # Gets all the values for the current table in the
  # database. Calls the adequate method to turn them
  # into instances.
  def self.all
    results = DATA_BASE.execute("select * from #{self}")
    create_from_results(results)
  end

  # Saves the current instance to the database. If it
  # is already present then it updates it, if not it
  # creates a new row.
  #
  # Returns:: If the query was successful or not.
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

private
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
end
