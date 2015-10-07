# Template Method Pattern
# Date: 27-Aug-2015
# Authors:
#   A01370815 Diego Galíndez Barreda
#   A01169999 Rodrigo Villalobos Sánchez

# File name: table_generator.rb

class TableGenerator

  def initialize(header, data)
    @header = header
    @data = data
  end

  def generate
    generate_header_row + (@data.map {|x| generate_row(x)}).join + generate_ending_row
  end

  def generate_header_row
    (@header.map {|x| generate_header_item(x)}).join
  end

  def generate_ending_row
    ''
  end

  def generate_item(item)
    item
  end

  def generate_row(row)
    (row.map {|x| generate_item(x)}).join
  end

  def generate_header_item(item)
    item
  end

end

class CSVTableGenerator < TableGenerator

  def generate_row(row)
    "#{(row.map {|x| generate_item(x)}).join(',')}\n"
  end

  def generate_header_row
    generate_row(@header)
  end

end

class HTMLTableGenerator < TableGenerator

  def generate_row(row, cell_tag = :cell_tag)
    if (cell_tag == :cell_tag)
      cell_tag = 'td'
    end
    "<tr>#{(row.map {|x| "<#{cell_tag}>#{generate_item(x)}"}).join("</#{cell_tag}>")}</#{cell_tag}></tr>\n"
  end

  def generate_header_row
    "<table>\n#{generate_row(@header, "th")}" 
  end

  def generate_ending_row
    "</table>\n"
  end

end

class AsciiDocTableGenerator < TableGenerator

  def generate_row(row)
    "|#{(row.map {|x| generate_item(x)}).join('|')}\n"
  end

  def generate_header_row
    "[options=\"header\"]\n" +
    generate_row(['==========']) +
    generate_row(@header)
  end

  def generate_ending_row
    generate_row(['=========='])
  end

end
