///______Get Seedstally name________

global get_orders, date_range,  seeds_tally, which_branch, 
files_open, order_line, TransactionID, group_list

group_list = ""



///_____Add the option to check the previous date range

TJExporter = info("databasename")

//select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date



//___change this for future files? 
which_branch = "seedstally"

if info("windows") notcontains str(which_branch)
    message "You need a "+which_branch+" Open"
    stop
    endif

files_open = info("windows")

seeds_tally = array(info("windows"), arraysearch( files_open, "*"+which_branch+"*", 1, ¶ ), ¶)
//message seeds_tally


////_____________//////


window seeds_tally

//_________Get List of completed group orders


firstrecord

find str(OrderNo) contains "." and «Status» contains "Com"

    if info("found")

    group_list = str(int(val(«OrderNo»)))

        endif

loop

    next

    if info('found')

    group_list = str(int(val(«OrderNo»)))+","+group_list

    endif

until (not info("found"))

arraydeduplicate group_list,group_list, ","

//displaydata group_list

selectwithin arraycontains( group_list, str(OrderNo)[1,"."][1,-2], "," ) or group_list contains str(OrderNo)

debug

////_______________________________////

////______import Parents and Children loop_______////

//initialize the window

openfile "TaxJarSeedsTotaller"

if info('windows') notcontains "TaxJarSeedsTotaller"
    message "Can't find TJseedsTotaller, fix that"
    stop
    endif

global TJseeds 

TJseeds = info("windowname")

//_____

window seeds_tally

firstrecord

extendedexpressionstack

global discountTotal, totalShipping,totalSalesTax,Order_line
            
            Order_line = ""

DoAgain:


//__loop through parents and children
loop

window seeds_tally
    if str(OrderNo) notcontains "."
        ////_________TaxJar SPecific______////
        //---start taxjar import loop ---///

        //---import loop ---///
        window seeds_tally

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

        toZip = ?(«9SpareText» = "",pattern(«Z»,"#####"),"")

        //____seeds does sell to canada 
        //+++++++
        ///______
        ///Make sure to set the logic for this for seeds and possibly OGS
        toCountry = ?(«9SpareText» = "", "US","CA")

        //Set needed values
        //Note: Shipping is mostly 0 here, with some exceptions
        //for parents, but a few children order with shipping
        //so use individual shipping for those

        discountTotal = «VolDisc» + «MemDisc»
        totalShipping = «$Shipping»
        totalSalesTax = «SalesTax»


            ///___Set if order is Taxable_____
        //seeds
        If Taxable contains "Y"
            TaxableBool = True()
        else 
            TaxableBool = False()
        endif

        downrecord
    endif

    if str(OrderNo) contains "." 
        ////___get children's info____////
        loop
            ///_____Split apart orders, set exemptions, put in proper place on TJExporter_____//


            Order_line = «Order» + ¶ + Order_line
            
            downrecord
        until str(OrderNo) notcontains "." or info("eof")
        

        arraystrip Order_line,¶

        //___Fills the seeds Totaller and exemptions 
        //___resets to first line of order
        window TJseeds

        call ExtractOrderInfo

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
    endif

window seeds_tally

until info("eof")




        









