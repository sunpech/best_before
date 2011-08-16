require 'date'

@input_string = ""
@earliest_date = Date.strptime("{ 2000, 1, 1 }", "{ %Y, %m, %d }")
@latest_date = Date.strptime("{ 2999, 12, 31 }", "{ %Y, %m, %d }")
@output_string = ""

def read_file
  
  begin
    
    file_path = ARGV[0]

    file = File.open(file_path)

    file.each {|line|
      @input_string << line.to_s
    }
  rescue 
    raise "Error reading file or file path not supplied"
    #Process.exit
  ensure    
    file.close unless file.nil?
  end

end

def validate_date
  valid_date_array = Array.new
  
  #check date_string is valid format
  valid_date_array = generate_date_array(@input_string)
  
  if valid_date_array.empty?
    # date passed already or not valid date, both considered illegal
    @output_string = @input_string + " is illegal"
  else
    # return first item in array, as it will be sorted
    @output_string = valid_date_array.first    
  end
end

def generate_date_array(str)
  array = Array.new
  
  begin
    re_date = /(\d{1,})\/(\d{1,})\/(\d{1,})/

    a = str[re_date, 1]
    b = str[re_date, 2]
    c = str[re_date, 3]    
  
    array << format_date(a, b, c)
    array << format_date(b, a, c)
    array << format_date(a, c, b)
    array << format_date(c, a, b)
    array << format_date(b, c, a)
    array << format_date(c, b, a)
  
    # Remove items from array that's not between 1/1/2000 and 12/31/2999, or invald
    array.delete_if { |x| x < @earliest_date or x > @latest_date  }
  
    return array.sort
  rescue
    puts @input_string + " is illegal"
    Process.exit
  end

end

def format_date(a, b, c)
  year = format_year(c).to_s
  month = b.to_s
  day = a.to_s
  
  date = Date.new
  
  begin
    date = Date.strptime("{ #{year}, #{month}, #{day} }", "{ %Y, %m, %d }")
    return date
  rescue
    # invalid date, no error message to be raised, default to 1/1/1900
    return Date.strptime("{ 1900, 1, 1 }", "{ %Y, %m, %d }")
  end

end

def format_year(str)
  # must be between 2000 and 2099
  
  begin
    year = Integer(str)    
  rescue ArgumentError
    raise "Invalid argument: cannot convert to integer."
  end
  
  if year >= 2000 and year <= 2999
    # no formating necessary
    
  elsif year > 0 and year < 99
    # format to YYYY
    year += 2000
  else
    # invalid date
    year = 1900
  end
  
  return year
end


def main
  read_file()
  
  validate_date()
  
  puts @output_string
  
end


main()
