require 'sqlite3'

DATA_BASE = SQLite3::Database.new('data.db')

class Student

  attr_reader :rowid
  attr_accessor :id, :name, :birth_day

  @@cache = {}

  def initialize(id, name, birth_day)
    @rowid = nil
    @id = id
    @name = name
    @birth_day = birth_day
  end
  
  def save
    if @rowid
      DATA_BASE.execute('update students set id=?, name=?, birth_day=? where rowid=?', [id, name, birth_day, @rowid])
    else
      DATA_BASE.execute('insert into students values (?, ?, ?)', [id, name, birth_day])
      @rowid = DATA_BASE.get_first_row('select max(rowid) from students')[0]
      @@cache[@rowid] = self
    end
  end

  def self.find(rowid)
    if @@cache.has_key?(rowid)
      @@cache[rowid]
    else
      row = DATA_BASE.get_first_row('select * from students where rowid=?', [rowid])
      return nil unless row
      student = Student.new(row[0], row[1], row[2])
      student.instance_variable_set(:@rowid, rowid)
      @@cache[@rowid] = student
      student
    end
  end

  def self.find_all
    students = Array.new
    DATA_BASE.execute('select rowid, id, name, birth_day from students') do |row|
      rowid = row[0]
      unless @@cache.has_key?(rowid)
        student = Student.new(row[1], row[2], row[3])
        student.instance_variable_set(:@rowid, rowid)
        @@cache[rowid] = student
      end
      students << @@cache[rowid]
    end
    students
  end

  def inspect
    "Student_#{@rowid}(id=#{@id}, name=#{@name}, brith_day=#{@birth_day})"
  end

  def to_s
    inspect
  end
  
end

s1 = Student.new(123, 'John', '1995-11-17')
s1.name = 'Johnny'
s1.save
s1.name = 'Whatever'
s1.save

puts Student.find(1)
puts Student.find_all
