global get_orders, date_range,  which_branch, 
files_open, order_line, TransactionID, check_overflow_count
permanent seeds_last_date_imported

check_overflow_count = 0
extendedexpressionstack 
noshow

define seeds_last_date_imported, datepattern(today(),"YYYY-MM-DD")

date_range = ""

which_branch = "seedstally"

openfile seeds_tally
//-----Select Date Range-----///

window seeds_tally

select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date

selectwithin full_group_list notcontains str(«OrderNo»)


//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2




showpage

firstrecord

global import_count

import_count = val(info("records"))

        
//noshow



loop

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

//---import loop ---///


window seeds_tally

global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal


///----Set Transcation ID------//
TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«FillDate»))))+"_"+"seeds"+"_"+str(OrderNo)


///----Is Order or Refund----//
// transactionType = //_____formula for figuring out if something is an order or a refund____///


//seeds orders are all going to be under "Order"

transactionType = "Order"


//---if refund, give reference--------//

// transactionRef = 



//----set date to proper format----//
format_Date = datepattern(date(datestr(«FillDate»)), "YYYY-MM-DD")



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

///_____Split apart orders, set exemptions, put in proper place on TJexporter_____///

///___Get the date in lines to start___///

global Order_line, PickSheet_line

Order_line = «Order»

//clipboard()=  replace(Order_line," ","!")

window TJseeds

//___Fills the seeds Totaller and exemptions 
//___resets to first line of order


call "ExtractOrderInfo"

window TJexporter


////_+_____________
/////_______Seeeds will just crash itself if you pull too many items in the loop, so there's a cutoff at 10k
check_overflow_count = val(info("records"))
    
        if check_overflow_count ≥ 10000
            speak "Limit reached, please export, select out Exported orders, and start another import"
            window "TaxJarExporter"
            call CleanUpData
            stop
            endif
            
            
window TJSeeds
loop

    //____pulls the relevant data out of the seeds line
    call FormattedOrderLine

    window TJexporter
    

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


debug


window seeds_tally

Exported = "Yes"

downrecord

until info("stopped") 




window TJexporter

call CleanUpData
endnoshow


speak "Seeds Import is complete"


//-----NOTE------//
/////////after import has succeeded, last import date needs to change
seeds_last_date_imported = datepattern(today(),"YYYY-MM-DD")

