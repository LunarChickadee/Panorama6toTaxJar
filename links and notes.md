## google sheet with details:
https://docs.google.com/spreadsheets/d/177nFNMqxcQUqMuo9Ld87clDcCaS3N3ow2YZ1XwBREo4/edit#gid=943266622

## Link To Taxjar Documentation:

https://support.taxjar.com/article/173-import-edit-transactions-with-a-csv#failtoupload



### possible code needs
To figure out nubmer of spaces in an order field and parse them, change the appropriate bits. You can paste the result of the replace

/*
this was when I was trying to get data out of picksheets, does work, but not useful
////____Give it delimiters_____

global item_line, parsed_line

item_line = «Item»

# clipboard() = replace(item_line," ","!")

«Item» = item_line[1,9]
«Sz» = striptoalpha(item_line[1,9])
«Qty»  = val(striptonum(item_line[10,12]))


;clipboard() = PickSheet_line

*/