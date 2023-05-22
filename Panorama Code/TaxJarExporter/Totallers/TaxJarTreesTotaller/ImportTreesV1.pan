global get_orders, date_range,  file_chosen, which_branch, files_open, order_line, TransactionID
local start_date, end_date
permanent trees_last_date_imported

//___change this for future files? 
which_branch = "treestally"

if info("windows") notcontains str(which_branch)
    message "You need a Trees Tally Open"
    stop
    endif

files_open = info("windows")

file_chosen = array(info("windows"), arraysearch( files_open, "*"+which_branch+"*", 1, ¶ ), ¶)
message file_chosen


define trees_last_date_imported, datepattern(today(),"YYYY-MM-DD")

date_range = ""




//-------Get Date Range------//
GetDate:
gettext "Last Date: "+trees_last_date_imported+" Next starting date?", start_date

start_date = date(start_date)

yesno "Start with "+ datepattern(start_date, "YYYY-MM-DD")+"?"
    if clipboard()="No"
        goto GetDate
        endif
        
gettext "Next starting date?", end_date
end_date = date(end_date)

yesno "End with "+ datepattern(end_date, "YYYY-MM-DD")+"?"
    if clipboard()="No"
        goto GetDate
        endif
 
//-----End Get Date Range----//


//-----Find Date Range-----///

window file_chosen

select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date

//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2

showpage

////_____Start Order Line Item Export______///
yesno "Are you Ready to start Importing orders?"
    if clipboard()="No"
        stop
        endif

openfile TaxJarTreesTotaller

if info('windows') notcontains TaxJarTreesTotaller
    message "Can't find TJTreesTotaller, fix that"
    stop
     endif
     

window file_chosen

firstrecord









////________End Order Line Item export_____/////
stop

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

//---import loop ---///

global transactionType, format_Date, toName, toStreet, toCity, toZip, toCountry, totalShipping,totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt

/*

//loop 


///----Set Transcation ID------//
TransactionID = "pan"+str(yearvalue(date(datestr(«EntryDate»))))+"seed"+str(OrderNo)


///----Is Order or Refund----//
// transactionType = //_____formula for figuring out if something is an order or a refund____///


//Trees all orders are orders

transactionType = "Order"


//---if refund, give reference--------//

// transactionRef = 



//----set date to proper format----//
format_Date = datepattern(date(datestr(«EntryDate»)), "YYYY-MM-DD")



//____Buyer Info_____///

toName = ?(«Con» ≠ "", «Con», «Group»)

toStreet = ?(«SAd» ≠ "",«SAd»,"")

toCity = ?(«Cit» ≠ "",«Cit»,"")

toState = «TaxState»

toZip = pattern(«Z»,#####)

//____Trees does not sell to Canada
toCountry = 'US"


/////////________Open up Totaller and parse out individual transations for the rest of the data_______////



*/
//-----NOTE------//
/////////after import has succeeded, last import date needs to change