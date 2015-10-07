#--------------------------------------------------------------------
# Computes the mean, median, mode and standard deviation of
# some integer numbers contained in a text file. Writes the
# results in a text file.
def text_cruncher(input_file_name, output_file_name)
  numbers = File.read(input_file_name).split.map(& :to_i)
  numbers.sort!
  size = numbers.size
  sum = numbers.inject(:+)
  mean = sum.to_f / size
  median = if size % 2 == 0
    (numbers[size / 2] + numbers[size / 2 - 1]) / 2.0
  else
    numbers[size / 2].to_f
  end
  freq = numbers.inject(Hash.new(0)) {|h, v| h[v] += 1; h }
  mode = numbers.max_by {|v| freq[v]}.to_f
  stdevp = Math.sqrt(numbers.map{|x| (x - mean) ** 2}.inject(:+) / numbers.size)
  File.write(output_file_name, "#{ mean } #{ median } #{ mode } #{ stdevp }")
end

#--------------------------------------------------------------------
# Computes the mean, median, mode and standard deviation of
# some integer numbers contained in a binary file. Writes the
# results in a binary file.
def binary_cruncher(input_file_name, output_file_name)
  numbers = File.binread(input_file_name).unpack('l<*')
  numbers.sort!
  size = numbers.size
  sum = numbers.inject(:+)
  mean = sum.to_f / size
  median = if size % 2 == 0
    (numbers[size / 2] + numbers[size / 2 - 1]) / 2.0
  else
    numbers[size / 2].to_f
  end
  freq = numbers.inject(Hash.new(0)) {|h, v| h[v] += 1; h }
  mode = numbers.max_by {|v| freq[v]}.to_f
  stdevp = Math.sqrt(numbers.map{|x| (x - mean) ** 2}.inject(:+) / numbers.size)
  output = [mean, median, mode, stdevp]
  File.write(output_file_name, output.pack('E*'))
end
