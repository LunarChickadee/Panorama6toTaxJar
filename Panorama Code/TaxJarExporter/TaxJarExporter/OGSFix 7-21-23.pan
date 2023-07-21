global get_orders, date_range,  which_branch, 
files_open, order_line, TransactionID, check_overflow_count
permanent ogs_last_date_imported

check_overflow_count = 0
extendedexpressionstack 
noshow

//______Gets to the right data ____///
define ogs_last_date_imported, datepattern(today(),"YYYY-MM-DD")

date_range = ""

which_branch = "ogstally"

openfile ogs_tally
//-----Select Date Range-----///

window ogs_tally

select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date
selectwithin OrderNo = int(OrderNo)

////____this block is for testing_____
selectwithin TaxState = "VT"

//selectwithin Taxable = "Y"

//selectwithin SalesTax > 0




//Get completed orders only
selectwithin «Status» = "Com"


firstrecord

 global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
    totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, IsTaxed, discountTotal,
    exemption, total_order, non_taxable_order, untaxed_items, untaxed_total

loop

    ////_________TaxJar SPecific______////
    //---start taxjar import loop ---///

    //---import loop ---///


    window ogs_tally



    ///----Set Transcation ID------//
    TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«FillDate»))))+"_"+"ogs"+"_"+str(OrderNo)


    ///----Is Order or Refund----//
    // transactionType = //_____formula for figuring out if something is an order or a refund____///


    //ogs orders are all going to be under "Order"

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

    //____ogs does sell to canada 
    //+++++++
    ///______
    ///Make sure to set the logic for this for seeds and possibly OGS
    toCountry = "US"

    ///___Set if order is Taxable_____
    //ogs
    If Taxable contains "Y"
        IsTaxed = True()
    else 
        IsTaxed = False()
    endif

    //__Get Discount, shipping, and sales tax totals
    discountTotal = «VolDisc» + «MemDisc»
    totalShipping = «$Shipping»
    totalSalesTax = «SalesTax»

    if totalSalesTax = 0
        IsTaxed = False()
    endif 


    ///____Check if there are untaxed_items in there
    untaxed_items = False()
    untaxed_total = 0

    if states_w_shipping_tax contains «TaxState»
        untaxed_total = (AdjTotal + «$Shipping») - TaxedAmount
    else 
        untaxed_total = AdjTotal - TaxedAmount
    endif

    if IsTaxed = True()
        case untaxed_total < 0.02
            untaxed_items = False()
        defaultcase
            untaxed_items = True()
        endcase
    endif

    
    //__Set fully non-taxable order_____///

    if IsTaxed = False()

        itemUnitPrice = «AdjTotal»

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
            
            «total_sales_tax» = totalSalesTax
            «total_shipping» = totalShipping

            //«item_discount» = discountTotal
        

            //Other Info
            «item_product_identifier» = "333338"
            «item_description» = "Batch of Exempt ogs Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = "wholesale" 
            «item_sales_tax» = totalSalesTax
            goto NextItem
    endif

// Set Fully taxed line

    if IsTaxed = True() AND untaxed_items = False()
    ///this makes sure even states with tax on shipping are included
        
        exemption = ""

        itemUnitPrice = «AdjTotal»
        
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
            
            «total_sales_tax» = totalSalesTax
            «total_shipping» = totalShipping
            //«item_discount» = discountTotal

            //«item_discount» = str(discountEach) 

            //Other Info
            «item_product_identifier» = "333333"
            «item_description» = "Batch of ogs Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax

            ////____need to add a record with the non-taxable part of orders
                //___use a copy/pasterecord and just change whats needed to get the total sales correct



            //debug
            goto NextItem
    endif


    ///default setting, if there's non-taxable items on there, figure out what that amount should be

    ///___do taxed record first
    
    

        exemption = ""

        itemUnitPrice = «AdjTotal» - untaxed_total
        
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
            
            
            «total_shipping» = totalShipping
            //«item_discount» = discountTotal/2


            //Other Info
            «item_product_identifier» = "333333"
            «item_description» = "Batch of ogs Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax
            
            copyrecord
            pasterecord
            
            «item_product_identifier» = "333338"
            «item_description» = "Batch of exempt ogs Product"
             «item_unit_price» = untaxed_total
             «total_sales_tax» = 0
            
            





NextItem:
    window ogs_tally

    Exported = "Yes"

    save

    downrecord

    IsTaxed = ""

until info("stopped") 




window TJexporter

endnoshow


speak "ogs Import is complete"


//-----NOTE------//
/////////after import has succeeded, last import date needs to change
ogs_last_date_imported = datepattern(today(),"YYYY-MM-DD")



normalexpressionstack