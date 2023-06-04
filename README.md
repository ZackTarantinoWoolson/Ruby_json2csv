## A CLI tool to convert JSON files to CSVs 

For each top-level nested key, a different CSV is generated.

(Right now this is just a Ruby script for proof of concept. Working on the CLI bit ) 

## Usage

Run this with ruby from your command line and pass in a JSON file that you want to convert
    ruby json2csv.rb -i test.json

## TODO
- [x] Parse JSON and find all Keys for the file
- [x] Set CSV headers based on all nested keys
- [x] Flatten nested data 
- [x] Create CSV based on flattened data
- [x] Remove hardcoding and use command line arguments for origin file
- [ ] Add linter