global get_orders, date_range,  seeds_tally, which_branch, 
files_open, order_line, TransactionID, TJExporter
local start_date, end_date
permanent seeds_last_date_imported

TJExporter = info("databasename")

//___change this for future files? 
which_branch = "ogstally"

if info("windows") notcontains str(which_branch)
    message "You need a "+which_branch+" Open"
    stop
    endif

files_open = info("windows")

ogs_tally = array(info("windows"), arraysearch( files_open, "*"+which_branch+"*", 1, ¶ ), ¶)
//message seeds_tally


window ogs_tally

//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2


showpage

firstrecord

global import_count

import_count = val(info("records"))

////_____Start Order Line Item Export______///
yesno "Are you Ready to start Importing orders?"
    if clipboard()="No"
        stop
        endif
        
//noshow

openfile "TaxJarOGSTotaller"

if info('windows') notcontains "TaxJarOGSTotaller"
    message "Can't find TJseedsTotaller, fix that"
    stop
    endif

global TJseeds 

TJseeds = info("windowname")

extendedexpressionstack

loop

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

//---import loop ---///


window ogs_tally

global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal


///----Set Transcation ID------//
TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«EntryDate»))))+"_"+"seeds"+"_"+str(OrderNo)


///----Is Order or Refund----//
// transactionType = //_____formula for figuring out if something is an order or a refund____///


//seeds orders are all going to be under "Order"

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

//____seeds does sell to canada 
//+++++++
///______
///Make sure to set the logic for this for seeds and possibly OGS
toCountry = "US"

///___Set if order is Taxable_____
//seeds
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

///_____Split apart orders, set exemptions, put in proper place on TJExporter_____///

///___Get the date in lines to start___///

global Order_line, PickSheet_line

Order_line = «Order»

//clipboard()=  replace(Order_line," ","!")

window TJseeds

//___Fills the seeds Totaller and exemptions 
//___resets to first line of order

call ExtractOrderInfo
debug

loop

    //____pulls the relevant data out of the seeds line
    call FormattedOrderLine

    window TJExporter

    addrecord

    ////Set all the proper Fields for each seeds line from the TJseeds file

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

    window TJseeds

    downrecord

until info("stopped")
//debug


window ogs_tally

downrecord

until info("stopped")


window TJExporter

//endnoshow

showpage

call CleanUpData


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
item_unit_price = ""

if (not info("empty"))
    message "Please fix these records with issues on required fields"
    endif


//-----NOTE------//
/////////after import has succeeded, last import date needs to change
seeds_last_date_imported = datepattern(today(),"YYYY-MM-DD")