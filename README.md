## A CLI tool to convert JSON files to CSVs 

For each top-level nested key, a different CSV is generated.

(Right now this is just a Ruby script for proof of concept. Working on the CLI bit ) 

## TODO
- [x] Parse JSON and find all Keys for the file
- [x] Set CSV headers based on all nested keys
- [x] Flatten nested data 
- [x] Create CSV based on flattened data
- [x] Remove hardcoding and use command line arguments for origin file
- [ ] Add linter