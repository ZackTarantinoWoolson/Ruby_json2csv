## A CLI tool to convert JSON files to CSVs 

This tool will flatten a given JSON file and generate a CSV with headers that retain their nested path

For each top-level nested key, a different CSV is generated.

### For example
Given the below JSON file
```
{
    "top_level_1":{
        "key":"value",
        "key":"value"
    },
    "top_level_2":{
        "key":"value",
        "key":"value"
    }
}
```

Two Seperate CSVs will be generated. One for top_level_1 and another for top_level_2

If only one file should be generated, the JSON should be wrapped in a parent key like so
```
{
    "parent_key":{
        "level_1":{
            "key":"value",
            "key":"value"
        },
        "level_2":{
            "key":"value",
            "key":"value"
        }
    }
}
```

## Installation

Download the latest Release from [Releases](https://github.com/ZackTarantinoWoolson/Ruby_json2csv/releases) and unzip the folder in the directory of your choosing.

## Usage

Navigate to the Ruby_json2csv folder you downloaded and start up a terminal from that folder.

Run the json2csv script with ruby from your command line and pass in a JSON file that you want to convert
```
ruby json2csv.rb -i \path\to\file\test.json
```

This will convert the file to a CSV and drop it into the output_files folder

Alternatively, add a bunch of JSON files to the input_files folder and use the -f option to convert them all
```
ruby json2csv.rb -f
```

## TODO
- [x] Parse JSON and find all Keys for the file
- [x] Set CSV headers based on all nested keys
- [x] Flatten nested data 
- [x] Create CSV based on flattened data
- [x] Remove hardcoding and use command line arguments for origin file
- [ ] Add linter