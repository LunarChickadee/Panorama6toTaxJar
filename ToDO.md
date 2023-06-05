# Find out why OGS is messing up when importing
## take off the noshow and test it while watching it
## it's filling exemptions with description names
## so set a step in the macro that if exemption isn't "" or wholesale, hold onto that order number, and then debug maybe? 

##### likely causes:
there's some extra data in one of the parts of the orders so description ends up one column too far hence the "bonk" noise from not being able to do what it expects in the fill part. 

##### Order lengths are from (at least at first glance):
# 1 = order is empty, but says complete
    - No of entries with status Com :204
    - Got rid of cancelled and known empty orders
    - got rid of anything that doesn't have item codes
# 8 = order is all zeros, so the other fields are filled in (consider just purging these from the tally with a check of all of the order lines first)
    - No of entries with status Com :13
# 9 = order where the itemNumber isn't detached from the Size code, ie. 7777-A instead of 7777 A
    - No of entries with status Com :4839
# 10 = also not detached
    - No of entries with status Com :9717
# 11 = our standard
    - No of entries with status Com :930

run the **check order lengths** function to test each selection once you have it 
use the **order lengths** function to get that data 


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