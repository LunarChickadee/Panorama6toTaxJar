global get_orders, date_range,  which_branch, 
files_open, order_line, TransactionID, check_overflow_count
permanent seeds_last_date_imported

check_overflow_count = 0
extendedexpressionstack 
noshow

//______Gets to the right data ____///
define seeds_last_date_imported, datepattern(today(),"YYYY-MM-DD")

date_range = ""

which_branch = "seedstally"

openfile seeds_tally
//-----Select Date Range-----///

window seeds_tally

select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date

selectwithin str(OrderNo) notcontains "."


//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2

selectwithin OrderNo = int(OrderNo)

firstrecord

 global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
    totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal,
    exemption, total_order, non_taxable_order, untaxed_items

loop

    ////_________TaxJar SPecific______////
    //---start taxjar import loop ---///

    //---import loop ---///


    window seeds_tally



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

        if totalSalesTax = 0
            TaxableBool = False()
        endif 

    
    ///____set the needed info from your seeds tally
    

    total_order = «Subtotal» //or OrderTotal?

    //AdjTotal = Subtotal - Discounts
    //TaxTotal not sure hwat this is for 
    //taxed amount shows how much of the order was taxable

    //__Set untaxed batch___


    if TaxableBool = False()
        exemption = "wholesale"

    itemUnitPrice = «Subtotal»

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
            
            «total_sales_tax» = totalSalesTax
            «total_shipping» = totalShipping

            «item_discount» = discountTotal
        

            //Other Info
            «item_product_identifier» = "777778"
            «item_description» = "Batch of Exempt Seed Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax

    else
        
        exemption = ""

        itemUnitPrice = «TaxedAmount»

        non_taxable_order = Subtotal - «TaxedAmount»

        if non_taxable_order > 0.50
            untaxed_items = True()
        else 
            untaxed_items = False()
        endif 
        
        
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
            
            «total_sales_tax» = totalSalesTax
            «total_shipping» = totalShipping

            case untaxed_items = False()
                «item_discount» = discountTotal
            case untaxed_items = True() 
                «item_discount» = discountTotal/2
            endcase
            //«item_discount» = str(discountEach) 

            //Other Info
            «item_product_identifier» = "888888"
            «item_description» = "Batch of Seed Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax

            if untaxed_items = True()
                copyrecord
                pasterecord
                «item_product_identifier» = "888889"
                «item_unit_price» = non_taxable_order
                «exemption_type» = "wholesale"
                «item_sales_tax» = 0
                «item_description» = "Batch of Exempt Seed Product"
            endif

            ////____need to add a record with the non-taxable part of orders
                //___use a copy/pasterecord and just change whats needed to get the total sales correct



            //debug

    endif



    window seeds_tally

    Exported = "Yes"

    save

    downrecord

until info("stopped") 




window TJexporter

endnoshow


speak "Seeds Import is complete"


//-----NOTE------//
/////////after import has succeeded, last import date needs to change
seeds_last_date_imported = datepattern(today(),"YYYY-MM-DD")



normalexpressionstack