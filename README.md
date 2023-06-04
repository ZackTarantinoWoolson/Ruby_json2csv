## A CLI tool to convert JSON files to CSVs 

For each top-level nested key, a different CSV is generated.

(Right now this is just a Ruby script for proof of concept. Working on the CLI bit ) 

## Usage
asd
Run this with ruby from your command line and pass in a JSON file that you want to convert
```
ruby json2csv.rb -i \path\to\file\test.json
```

This will convert the file to a CSV and drop it into the output_files folder

Or, add a bunch of JSON files to the input_files folder and use the -f option to convert them all
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