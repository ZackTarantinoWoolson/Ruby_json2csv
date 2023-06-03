require "csv"
require "json"

# Location to save script output. Must be csv format. (Default: "data.csv")
# @Output_Location = "test#{Time.now.to_i}.csv"

# Headers for the final CSV, in order.

# All Top Level Keys of the JSON file
@Top_Level_Keys = Hash.new


def create_csv(data_hash_array, title_key, csv_headers)
  csv_config = {
    write_headers: true,
    force_quotes: true,
    encoding: "utf-8",
  }

  output_location="output_files/#{title_key}_#{Time.now.to_i}.csv"

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

# def make_csv_headers(all_keys,csv_headers)
#   all_keys.each do |key|
#     csv_headers << key.to_s
#   end
# end

def build_data_hash(json, csv_headers)

  csv_data = Array.new

  # p "top of build data hash",json

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

module Enumerable
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
end


file = File.read("example_data/response.json")
json_file = JSON.parse(file, symbolize_names: true)
@Top_Level_Keys= json_file.keys

# For each top level key, loop through and find all other keys.
# Use keys to build column headers
# Create CSV for each top level key
@Top_Level_Keys.each do |key|

  p '',key,''

  csv_headers = Array.new
  all_keys = Array.new

  # find_all_nested(json_file[key], all_keys)
  # all_keys.uniq!

  # make_csv_headers(all_keys,csv_headers)
  # p all_keys


  data_hash_array=build_data_hash(json_file[key],csv_headers)
  create_csv(data_hash_array, key, csv_headers)

  # p csv_headers

  # p json_file[key]
  # p json_file[key].flatten_nests_and_save_paths

  # csv_headers.find { |h1| p h1["location_id_ne_attribute"] }

  p '',''

end






# p json_file[:profile][:attributes].respond_to?('keys')

# p json_file[:profiles][0].class
# p json_file[:profiles].kind_of?(Array)

# json_file.keys.each do |key|
#   p json_file[key].keys
# end











# sessions=[]

# json_file["profiles"].each do |ses|
#     sessions<<ses
# end

# sessions.each do |ses|
#     p ses["attributes"].empty?
#     unless ses["attributes"].empty?
#       ses["legacy_id_ne_attribute"]=ses["attributes"]["legacy_id_ne_attribute"]
# ses["cgl_identity_name"]=ses["attributes"]["cgl_identity_name"]
# ses["cgl_date_of_last_validation"]=ses["attributes"]["cgl_date_of_last_validation"]
# ses["cgl_date_of_next_validation"]=ses["attributes"]["cgl_date_of_next_validation"]
# ses["cgl_firstname"]=ses["attributes"]["cgl_firstname"]
# ses["cgl_lastname"]=ses["attributes"]["cgl_lastname"]
# ses["cgl_position_description"]=ses["attributes"]["cgl_position_description"]
# ses["cgl_position_title"]=ses["attributes"]["cgl_position_title"]
# ses["personal_identity_type"]=ses["attributes"]["personal_identity_type"]
# ses["cgl_businessfunction_code"]=ses["attributes"]["cgl_businessfunction_code"]
# ses["cgl_businessfunction_name"]=ses["attributes"]["cgl_businessfunction_name"]
# ses["cgl_nonhr_department"]=ses["attributes"]["cgl_nonhr_department"]
# ses["cgl_jointventure_name"]=ses["attributes"]["cgl_jointventure_name"]
# ses["cgl_nonhr_location"]=ses["attributes"]["cgl_nonhr_location"]
# ses["cgl_manager_username"]=ses["attributes"]["cgl_manager_username"]
# ses["cgl_manager_name"]=ses["attributes"]["cgl_manager_name"]
# ses["cgl_termination_date"]=ses["attributes"]["cgl_termination_date"]
# ses["personal_type"]=ses["attributes"]["personal_type"]
# ses["cgl_location_type"]=ses["attributes"]["cgl_location_type"]
#     end
# end

# create_csv(sessions, @output_location)
