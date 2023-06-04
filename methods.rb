require "csv"
require "json"

module ConvertJSON
  # All Top Level Keys of the JSON file
  @Top_Level_Keys = Hash.new

  def create_csv(data_hash_array, title_key, csv_headers, file_name)
    csv_config = {
      write_headers: true,
      force_quotes: true,
      encoding: "utf-8",
    }

    output_location="output_files/#{file_name}_#{title_key}_#{Time.now.to_i}.csv"

    csv_file = CSV.open(output_location, "w", :write_headers => true, :force_quotes => true, :encoding => "utf-8") do |csv|
      csv.to_io.write "\uFEFF"
      csv << csv_headers
      data_hash_array.each do |r|
        row_arr = []
        csv_headers.each do |h|
          row_arr << "#{r[h]}"
        end
        csv << row_arr.dup
      end
    end
  end

  def find_all_nested(json,all_keys)
    if(json.kind_of?(Array))
      json.each do |element|
        find_all_nested(element, all_keys)
      end
    else
      if(json.respond_to?('keys'))
        json.keys.each do |key|
          all_keys << key
          find_all_nested(json[key],all_keys)
        end
      end
    end
  end

  def build_data_hash(json, csv_headers)

    csv_data = Array.new

    if(json.kind_of?(Array))   
      json.each do |ele|

        flattened_array= ele.flatten_nests_and_save_paths
        flattened_array=flattened_array.transform_keys(&:to_s)

        # build list of all keys to use for csv headers
        flattened_array.each do |k,v| csv_headers << k end

        csv_data<<flattened_array

        csv_headers.uniq!
      end
    else
        flattened_array= json.flatten_nests_and_save_paths
        flattened_array=flattened_array.transform_keys(&:to_s)

        # build list of all keys to use for csv headers
        flattened_array.each do |k,v| csv_headers << k end

        csv_data<<flattened_array

        csv_headers.uniq!
    end

    csv_data
  end

  # module Enumerable
    def flatten_nests_and_save_paths(path_prefix = nil)
      result = {}

      self.each_with_index do |ele, iter|
        if ele.kind_of?(Array) then k, v = ele 
        else  k, v = iter, ele 
        end

        # Assign the path key name for the later result hash
        key = path_prefix ? "#{path_prefix}.#{k}" : k 

        if v.kind_of?(Enumerable)
          # recursive call to flatten child elements
          result.merge!(v.flatten_nests_and_save_paths(key)) 
        else
          result[key] = v
        end
      end

      result
    end
  # end

  def process_file(input_file)
    file = File.read(input_file)
    json_file = JSON.parse(file, symbolize_names: true)
    @Top_Level_Keys= json_file.keys

    # For each top level key, loop through and find all other keys.
    # Use keys to build column headers
    # Create CSV for each top level key
    @Top_Level_Keys.each do |key|

      p "Creating CSV for #{key}..."

      csv_headers = Array.new
      all_keys = Array.new


      data_hash_array=build_data_hash(json_file[key],csv_headers)
      create_csv(data_hash_array, key, csv_headers, File.basename(input_file, ".*"))

      p "CSV Created.."
    end

    p "json2csv complete!"
  end
end