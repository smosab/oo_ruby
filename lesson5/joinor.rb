array = %w(1)

# array.map do |n|
#   puts n
# end
require 'pry'

def joinor(array, delimiter, conjunction)
  new_array_string = ''
  array.length.times do |n|
    # binding.pry
    if array.index(array.max) == 0
      new_array_string += array[n].to_s
      break
    elsif
      n != array.index(array.max)
      new_array_string += array[n].to_s + delimiter
    else
      new_array_string += conjunction + array[n].to_s
    end
  end
  new_array_string
end


puts joinor(array, ", " , "or ")



