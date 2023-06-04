require_relative 'methods.rb'
include ConvertJSON

def process_argv(option)
    case option
    when "-h"
      puts "This is the help menu."
      puts "  -v Prints the version"
      puts "  -i Enter the Input file name"
      puts "  -f Executes conversion on all files in input_files directory"
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
      exit
    when "-f"
      Dir.glob("input_files/*.json").each do |filename|
        next if filename == '.' or filename == '..'
        ConvertJSON::process_file(filename)
      end
      exit
    end
end

if(ARGV.size > 2)
  raise ArgumentError, "Too many Arguments."
  exit
end

ARGV.each { |option| process_argv(option) }
