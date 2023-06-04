require_relative 'convert_json_to_csv.rb'
include ConvertJSON

def process_argv(option)
    case option
    when "-h"
      puts "This is the help menu."
      puts "  -v Prints the version"
      puts "  -i Enter the Input file name"
      puts ""
      puts "Usage:"
      puts "  Enter the Input File name like so:"
      puts "  ruby json2csv.rb -i test.json"
      exit
    when "-v"
      puts "1.0.1"
      exit
    when "-i"
      ConvertJSON::process_file(ARGV[1])
    end
end

if(ARGV.size > 2)
  raise ArgumentError, "Too many Arguments."
  exit
end

ARGV.each { |option| process_argv(option) }
