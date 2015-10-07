# File: student.rb

class Student

  attr_reader :name, :id
  attr_accessor :anual_income

  MIN_SCHOLARSHIP_AVERAGE = 85
  MAX_ANUAL_INCOME = 15_000
  ERROR_CODE = -1

  def initialize(name, id, anual_income)
    @name = name
    @id = id
    @anual_income = anual_income
    @grades = []
  end

  def add_grade(grade)
    @grades << grade
    self
  end

  def scholarship_worthy?
    # Nothing reasonable to do if this student has currently no grades.
    raise RuntimeError if @grades.empty?

    # A student is worthy of a scholarship if he/she has good grades and
    # is poor.
    (calculate_average >= MIN_SCHOLARSHIP_AVERAGE) and (@anual_income < MAX_ANUAL_INCOME)
  end

  def display_summary
    display_personal_information

    puts "Grade average: #{ calculate_average }"

    display_disclaimer
  end

  def calculate_average
    @grades.inject { |sum, grade| sum += grade } / @grades.size.to_f
  end

  private

  def display_personal_information
    puts "Name: #{ @name } ID: #{ @id }"
    puts "Anual income: #{ @anual_income }"
  end

  def display_disclaimer
    puts 'The contents of this class must not be considered an offer,'
    puts 'proposal, understanding or agreement unless it is confirmed'
    puts 'in a document signed by at least five blood-sucking lawyers.'
  end

end
