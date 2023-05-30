///______Get ogstally name________

global get_orders, date_range, order_line, TransactionID, ogs_group_list, ogs_full_group_list

ogs_group_list = ""

openfile ogs_tally


window ogs_tally



select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date

//_________Get List of completed group orders


firstrecord

find str(OrderNo) contains "." and «Status» contains "Com"

    if info("found")

    ogs_group_list = str(int(val(«OrderNo»)))
    
    else
    
    rtn

        endif


//noshow
loop

    next

    if info('found')

    ogs_group_list = str(int(val(«OrderNo»)))+","+ogs_group_list

    endif

until (not info("found"))



//displaydata ogs_group_list

selectwithin arraycontains( ogs_group_list, str(OrderNo)[1,"."][1,-2], "," ) or ogs_group_list contains str(OrderNo)

arrayselectedbuild ogs_full_group_list, ¶, "", str(OrderNo)

debug

////_______________________________////

////______import Parents and Children loop_______////

//initialize the window

openfile "TaxJarOGSTotaller"

if info('windows') notcontains "TaxJarOGSTotaller"
    message "Can't find TaxJarOGSTotaller, fix that"
    stop
    endif

//_____

window ogs_tally

firstrecord

extendedexpressionstack

global discountTotal, totalShipping,totalSalesTax,Order_line
            
            Order_line = ""

DoAgain:


//__loop through parents and children
loop

window ogs_tally
    if str(OrderNo) notcontains "."
        ////_________TaxJar SPecific______////
        //---start taxjar import loop ---///

        //---import loop ---///
        window ogs_tally

        global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
        totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal


        ///----Set Transcation ID------//
        TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«EntryDate»))))+"_"+"ogs"+"_"+str(OrderNo)


        ///----Is Order or Refund----//
        // transactionType = //_____formula for figuring out if something is an order or a refund____///


        //ogs orders are all going to be under "Order"

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

        //____ogs does sell to canada 
        //+++++++
        ///______
        ///Make sure to set the logic for this for seeds and possibly OGS
        //toCountry = ?(«9SpareText» = "", "US","CA")

        //Set needed values
        //Note: Shipping is mostly 0 here, with some exceptions
        //for parents, but a few children order with shipping
        //so use individual shipping for those

        discountTotal = «VolDisc» + «MemDisc»
        totalShipping = «$Shipping»
        totalSalesTax = «SalesTax»


            ///___Set if order is Taxable_____
        //ogs
        If Taxable contains "Y"
            TaxableBool = True()
        else 
            TaxableBool = False()
        endif

        downrecord
    endif
    

    if str(OrderNo) contains "." 

    Order_line = "" //_____addd this to seeeeeeds  _______________________________________________//////

        ////___get children's info____////
        loop
            ///_____Split apart orders, set exemptions, put in proper place on TJexporter_____//


            Order_line = «Order» + ¶ + Order_line
            
            downrecord
        until str(OrderNo) notcontains "." or info("eof")
        

        arraystrip Order_line,¶

        //___Fills the ogs Totaller and exemptions 
        //___resets to first line of order
        window TJogs

        call ExtractOrderInfo

            loop

            //____pulls the relevant data out of the ogs line
            call FormattedOrderLine
            
            window TJexporter

            addrecord

            ////Set all the proper Fields for each ogs line from the TJogs file

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

            window TJogs

            downrecord
            until info("stopped")
    endif
debug
window ogs_tally

until info("eof")
endnoshow

speak "OGS Groups has finished, aaaaaaaaaaaaaaaaaaaaaaaaaa a a a a a a"
stop

