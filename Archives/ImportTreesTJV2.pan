global get_orders, date_range,  tree_tally, which_branch, files_open, order_line, TransactionID
local start_date, end_date
permanent trees_last_date_imported

//___change this for future files? 
which_branch = "treestally"

if info("windows") notcontains str(which_branch)
    message "You need a "+which_branch+" Open"
    stop
    endif

files_open = info("windows")

tree_tally = array(info("windows"), arraysearch( files_open, "*"+which_branch+"*", 1, ¶ ), ¶)
//message tree_tally


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

window tree_tally

select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date

//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2

showpage

firstrecord

////_____Start Order Line Item Export______///
yesno "Are you Ready to start Importing orders?"
    if clipboard()="No"
        stop
        endif

openfile "TaxJarTreesTotaller"

if info('windows') notcontains "TaxJarTreesTotaller"
    message "Can't find TJTreesTotaller, fix that"
    stop
    endif

global TJTrees 

TJTrees = info("windowname")

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

//---import loop ---///


window tree_tally

global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt


///----Set Transcation ID------//
TransactionID = "pan"+str(yearvalue(date(datestr(«EntryDate»))))+"seed"+str(OrderNo)


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


/////////________Open up Totaller and parse out individual transations for the rest of the data_______////

///_____Split apart orders, set exemptions, put in proper place on TJExporter_____///

///___Get the date in lines to start___///

global Order_line, Totaller, PickSheet_line

Totaller = "TaxJarTreesTotaller"

Order_line = «Order»


//clipboard()=  replace(Order_line," ","!")

window TJTrees

call ExtractOrderInfo



////________End Order Line Item export_____/////
stop




//-----NOTE------//
/////////after import has succeeded, last import date needs to change