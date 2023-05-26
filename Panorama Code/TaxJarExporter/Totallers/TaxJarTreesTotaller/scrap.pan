global get_orders, date_range, which_branch, 
files_open, order_line, TransactionID, TJExport
local start_date, end_date
permanent trees_last_date_imported


define trees_last_date_imported, datepattern(today(),"YYYY-MM-DD")

date_range = ""







//-----Find Date Range-----///

window trees_tally

//select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date

//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2

showpage

firstrecord

global import_count

import_count = val(info("records"))



extendedexpressionstack

loop

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

//---import loop ---///


window trees_tally

global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal


///----Set Transcation ID------//
TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«EntryDate»))))+"_"+"trees"+"_"+str(OrderNo)


///----Is Order or Refund----//
// transactionType = //_____formula for figuring out if something is an order or a refund____///


//Trees orders are all going to be under "Order"

transactionType = "Order"


//---if refund, give reference--------//

// transactionRef = 



//----set date to proper format----//
format_Date = datepattern(date(datestr(«EntryDate»)), "YYYY-MM-DD")



//____Buyer Info_____///

toName = ?(«Con»≠"", «Con», «Group»)

toStreet = ?(«SAd»≠"",«SAd»,"")

toCity = ?(«Cit»≠"",«Cit»,"")

toState = «TaxState»

toZip = pattern(«Z»,"#####")

//____Trees does not sell to Canada
toCountry = "US"

///___Set if ordre is Taxable_____
//Trees
If Taxable contains "Y"
    TaxableBool = True()
else 
    TaxableBool = False()
endif

//__Get Discount, shipping, and sales tax totals
discountTotal = «VolDisc» + «MemDisc»
totalShipping = «$Shipping»
totalSalesTax = «SalesTax»


/////////________Open up Totaller and parse out individual transations for the rest of the data_______////

///_____Split apart orders, set exemptions, put in proper place on TJexporter_____///

///___Get the date in lines to start___///

global Order_line, PickSheet_line

Order_line = «Order»

//clipboard()=  replace(Order_line," ","!")

window TJtrees

//___Fills the trees Totaller and exemptions 
//___resets to first line of order
call ExtractOrderInfo


loop

    //____pulls the relevant data out of the trees line
    call FormattedOrderLine

    window TJexporter

    addrecord

    ////Set all the proper Fields for each Tree line from the TJTrees file

    ///TransID
    «provider» = "panorama"
    «transaction_id» = TransactionID
    «transaction_type» = transactionType
    //transaction_reference_id = // only for refunds
    «transaction_date» = format_Date

    ///Shipped to 
    «to_name» = toName
    «to_street» = toStreet
    «to_city» = toCity
    «to_state» = toState
    «to_zip» = toZip
    «to_country» = toCountry

    //Dollars and Cents
    «total_shipping» = str(totalShipping)
    «total_sales_tax» = str(totalSalesTax)
    «item_discount» = str(discountEach) 

    //Other Info
    «item_product_identifier» = prodID
    «item_description» = itemDesc
    «item_quantity» = itemQty
    «item_unit_price» = itemUnitPrice
    «exemption_type» = exemption 

    window TJtrees

    downrecord

until info("stopped")


window trees_tally

downrecord

until info("stopped")


window TJexporter


//Cleanup zeros and blanks

loop
    find item_quantity = "" or val(item_quantity) = 0
        if info("found")
            deleterecord
        endif
until (not info("found"))

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


//-----NOTE------//
/////////after import has succeeded, last import date needs to change
trees_last_date_imported = datepattern(today(),"YYYY-MM-DD")