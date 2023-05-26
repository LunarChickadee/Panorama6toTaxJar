Finish setting up the OGS exporter. it's throwing out a lot of weird data

find out if OGS does group orders, if so, build a group loop

set up the order of import starting with seeds group orders
- then excluding those and importing the rest of that month
- then OGS
- then finally Trees

Add saves in between each step in case it crashes

test exporting that big of a CSV, if it doesn't work, do selections and export those. 


make sure cleanupdata runs after all the imports

- fix this in the other error checkers: 
////______find likely errors______///
select provider = "" OR
transaction_id = "" OR 
transaction_date = "" OR 
to_state = "" OR 
to_zip = "" OR 
to_country = "" OR
item_product_identifier = "" OR 
item_quantity = "" OR
val(item_quantity) = 0 OR 
item_unit_price = 0

if (not info("empty"))
    message "Please fix these records with issues on required fields"
    endif
d