require "csv"
require "json"

# Location to save script output. Must be csv format. (Default: "data.csv")
@output_location = "dives.csv"

# Headers for the final CSV, in order.
@CSV_Headers = ["id", "profile_type_id", "uid", "name", "status", "legacy_id_ne_attribute", "cgl_identity_name", "cgl_date_of_last_validation", "cgl_date_of_next_validation", "cgl_firstname", "cgl_lastname", "cgl_position_description", "cgl_position_title", "personal_identity_type", "cgl_businessfunction_code", "cgl_businessfunction_name", "cgl_nonhr_department", "cgl_jointventure_name", "cgl_nonhr_location", "cgl_manager_username", "cgl_manager_name", "cgl_termination_date", "personal_type", "cgl_location_type"]

@Top_Level_Keys = Hash.new


def create_csv(data_hash_array, output_location)
  csv_config = {
    write_headers: true,
    force_quotes: true,
    encoding: "utf-8",
  }
  csv_file = CSV.open(output_location, "w", :write_headers => true, :force_quotes => true, :encoding => "utf-8") do |csv|
    csv.to_io.write "\uFEFF"
    csv << @CSV_Headers
    data_hash_array.each do |r|
      row_arr = []
      @CSV_Headers.each do |h|
        row_arr << "#{r[h]}"
      end
      csv << row_arr.dup
    end
  end
end

def check_if_nested(json)
  if(json.kind_of?(Array))
    # p "is array"

    json.each do |element|
      check_if_nested(element)
    end
  else
    # p "is not array"

    if(json.respond_to?('keys'))
      # p 'responds'

      json.keys.each do |key|
        # p "in each |   #{key}"
        check_if_nested(json[key])
      end

    else
      # p 'does not resposnd'
    end
  end
end

file = File.read("example_data/response.json")
json_file = JSON.parse(file, symbolize_names: true)
@Top_Level_Keys= json_file.keys

check_if_nested(json_file)





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
