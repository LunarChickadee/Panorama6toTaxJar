___ PROCEDURE treeretotaller ___________________________________________________
local subtotal, oray, taxtotal, wttotal, retotalwindow, itemno, lightshipping, taxable
global rayj
retotalwindow=info("windowname")
oray=""
openfile "45tree price lookup"
windowtoback "45tree price lookup"
window retotalwindow
;opensecret "45tree price lookup"
oray=""
taxtotal=0
taxable=0

field Comment
formulafill ?(Comment contains "sp", "special price", ?(Comment contains "st", "stewardship", ?(Comment contains "out", "out-of-stock", 
?(Comment contains "r", "replacement", ?(Comment contains "f", "filled", Comment)))))
field Comment2
formulafill ?(Comment2 contains "sp", "special price", ?(Comment2 contains "st", "stewardship", ?(Comment2 contains "out", "out-of-stock", 
?(Comment2 contains "r", "replacement", ?(Comment2 contains "f", "filled", Comment2)))))
field Comment
firstrecord
loop
;Item=Item+Sz
itemno=?(Sz="A", val(str(Item)+"1"),?(Sz="B", val(str(Item)+"2"),?(Sz="C",val(str(Item)+"3"),
            ?(Sz="D", val(str(Item)+"4"),?(Sz="E", val(str(Item)+"5"),?(Sz="F", val(str(Item)+"6"),
            ?(Sz="G", val(str(Item)+"7"),?(Sz="H", val(str(Item)+"8"), val(str(Item)+"9")))))))))
           ; message itemno

if val(Item)=999
Qty=Qty
else
Qty=val(lookup("45tree price lookup","StockNo",itemno,"BdlSz","",0))
endif
Price=?(«Comment» contains "special price" or «Comment2» contains "special price", Price, ?(«Comment» contains "stewardship" or «Comment2» contains "stewardship", 60.00, ?(val(Item)=999 and Sz="A", 6.00, ?(val(Item)=999, Price,
 ?(staff="staff", lookup("45tree price lookup","StockNo",itemno,"Staff",0,0), lookup("45tree price lookup","StockNo",itemno,"Price",0,0))))))
«$Total»=?(Comment contains "replacement",0, val(Fill)*Price)
Light=lookup("45tree price lookup","StockNo",itemno,"Light","",0)
Light=?(val(Item)=999 and Sz="A", "L", ?(Light="","H",Light))
       if lookup("45tree price lookup",str("3#"),«Item»,"TaxableSt","",0) contains taxstate
        taxable=taxable+val(Fill)*Price
    endif
downrecord
until info("stopped")

field «$Total»
Total
lastrecord
subtotal=«$Total»
;taxtotal=«$Total»
taxtotal=?(taxstate="VT" or taxstate="MA",taxable,«$Total»)

deleterecord
selectall
field Item
sortup
lastrecord
if Item=""
deleterecord
endif
save
field Light
arraybuild lightshipping,",","TallyRetotaller",Light
if lightshipping contains "H"
rayj="N"
else rayj="Y"
endif
field PrintSort
formulafill lookup("45tree price lookup","Item",Item+"-"+Sz, "PrintSort","",0)
arraybuild printsort,",","TallyRetotaller",PrintSort

arraybuild oray, ¶, info("databasename"), Item+"-"+Sz+¬+str(Qty)+¬+Fill+¬+¬+?(Comment contains "stew" or Comment contains "special" or Comment contains "filled" or Comment contains "out",Comment,Comment2)+¬+
    str(Price)+¬+pattern(«$Total»,"$#.##")+¬+?(val(Item)=999, "See comments", lookup("45tree price lookup","Item",Item+"-"+Sz,"Name","",0))
arrayfilter oray, oray ¶, str(seq())+")"+¬+import()
;window "45tree price lookup"
;closewindow
;window retotalwindow
;closewindow
window waswindow
Subtotal=subtotal
TaxTotal=taxtotal
Order=oray
;«Original Order»=oray
;call ".refiguretreeshipping"
___ ENDPROCEDURE treeretotaller ________________________________________________

___ PROCEDURE test _____________________________________________________________

___ ENDPROCEDURE test __________________________________________________________

___ PROCEDURE treestaffretotaller ______________________________________________
local subtotal, oray, taxtotal, wttotal, retotalwindow, itemno
retotalwindow=info("windowname")
oray=""
openfile "45tree price lookup"
windowtoback "45tree price lookup"
window retotalwindow
;opensecret "45tree price lookup"
oray=""
taxable=0
field Comment
formulafill ?(Comment contains "s", "special price", ?(Comment contains "r", "replacement", Comment)) 
firstrecord
loop
;Item=Item+"-"+Sz
itemno=?(Sz="A", val(str(Item)+"1"),?(Sz="B", val(str(Item)+"2"),?(Sz="C",val(str(Item)+"3"),
            ?(Sz="D", val(str(Item)+"4"),?(Sz="E", val(str(Item)+"5"),?(Sz="F", val(str(Item)+"6"),
            ?(Sz="G", val(str(Item)+"7"),?(Sz="H", val(str(Item)+"8"), val(str(Item)+"9")))))))))

if val(Item)=999
Qty=Qty
else
Qty=val(lookup("45tree price lookup","StockNo",itemno,"BdlSz","",0))
endif
Price=?(Comment contains "special price", Price, ?(val(Item)=999 and Sz="A", 5.00, ?(val(Item)=999, Price, lookup("45tree price lookup","StockNo",itemno,"Staff",0,0))))
Light=?(val(Item)=999 and Sz="A", "L", ?(Light="","H",Light))
«$Total»=?(Comment="replacement",0, val(Fill)*Price)
       if lookup("45tree price lookup",str("3#"),«Item»,"TaxableSt","",0) contains taxstate
       taxable=taxable+val(Fill)*Price
       endif
downrecord
until info("stopped")
field «$Total»
Total
lastrecord
subtotal=«$Total»
;taxtotal=«$Total»
taxtotal=?(taxstate="VT" or taxstate="MA",taxable,«$Total»)

deleterecord
selectall
field Item
sortup
lastrecord
if Item=""
deleterecord
endif
save
arraybuild oray, ¶, info("databasename"), Item+"-"+Sz+¬+str(Qty)+¬+Fill+¬+Comment+¬+
    str(Price)+¬+pattern(«$Total»,"$#.##")+¬+?(val(Item)=999, "See comments", lookup("45tree price lookup","Item",Item+"-"+Sz,"Name","",0))
arrayfilter oray, oray ¶, str(seq())+")"+¬+import()
;window "45tree price lookup"
;closewindow
;window retotalwindow
;closewindow
window waswindow
Subtotal=subtotal
TaxTotal=taxtotal
Order=oray
«Original Order»=oray
;call ".refiguretreeshipping"
___ ENDPROCEDURE treestaffretotaller ___________________________________________

___ PROCEDURE (TaxJar) _________________________________________________________

___ ENDPROCEDURE (TaxJar) ______________________________________________________

___ PROCEDURE OldImportTrees ___________________________________________________
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

downrecord


select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date

//selectwithin length(«Order») > 2

//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2

showpage

////_____Start Order Line Item Export______///










////________End Order Line Item export_____/////
stop

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

global OrdRef, format_Date, toName, toStreet, toCity

/*

firstrecord

loop 
///----Set Transcation ID------//
TransactionID = "pan"+str(yearvalue(date(datestr(«EntryDate»))))+"seed"+str(OrderNo)


///----Is Order or Refund----//
// OrdRef = //_____formula for figuring out if something is an order or a refund____///


//---if refund, give reference--------//

//-------waiting for reply from Ryan------//
// transactionRef = 
// if OrdRef = Refund (order_with_refund | order with partial refund 
// else "" 


//----set date to proper format----//
format_Date = datepattern(date(datestr(«EntryDate»)), "YYYY-MM-DD")

toName = ?(«Con» ≠ "", «Con», «Group»)

toStreet = ?(«MAd» ≠ "",«MAd»,"")

toCity = ?(«City» ≠ "",«City»,"")


//----add all the pieces to our new orderline
orderline = "panorama" + ¬ + TransactionID + ¬ + OrdRef + ¬ + format_Date + ¬
*/
//-----NOTE------//
/////////after import has succeeded, last import date needs to change
___ ENDPROCEDURE OldImportTrees ________________________________________________

___ PROCEDURE ExtractOrderInfo _________________________________________________
/// State: Tally has a list of desired orders, 
//now we need to loop through, 
//break them apart, check for exemptions, 
//and append them to the list as a set of 
//line item parts to a single order for each transaction ID/OrderNo


window TJTrees

openfile "&@Order_line"

///___find out if there are exempt Items

firstrecord

loop

if val(Fill) < 1
    deleterecord
endif

call CheckExemptions

///____Cleanup Itemname____
global changeThese, toThese

changeThese = "E-;*-"
toThese = ";"
«Item» = replacemultiple(«Item»,changeThese,toThese,";")



downrecord

until info("stopped")

firstrecord





___ ENDPROCEDURE ExtractOrderInfo ______________________________________________

___ PROCEDURE CheckExemptions __________________________________________________
global has_exemptions, which_branch


case info("databasename") contains "ogs"
    which_branch = "ogs"
case info("databasename") contains "seeds"
    which_branch = "seeds"
case info("databasename") contains "trees"
    which_branch = "trees"
endcase

if TaxableBool = False()
    «Exempt» = "wholesale"
    rtn
endif
    


///this should only be called from the various totallers



///build the list of item_check ANDs and ORs automatically through this google sheet
//https://docs.google.com/spreadsheets/d/1TY_6LZcwb2IiM0OrrwpIqtH4BEYujRXEF3ZnVomKJmc/edit?usp=sharing
/////note: carriage returns after OR's are purely for aesthetics and you can paste one long equation to replace them for the sake of time
has_exemptions = "CT,MA,MD,MN,NY,RI,VT"

///____Note, arraycontains requires an EXACT match, so make sure there's no spaces
if arraycontains(has_exemptions,toState,",") = 0
    rtn
endif

///___Is this item Exempt?_____//
global item_check
item_check = val(striptonum(«Item»))


///_____Exemptions for CT______///

if toState = "CT"

    case which_branch contains "seeds"
    
        if (item_check ≥ 0 AND  item_check ≤ 797) OR 
        (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
        (item_check ≥ 5976 AND  item_check ≤ 5980)
            «Exempt» = "wholesale"
            endif

    case  which_branch contains "ogs"
    
        if (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
        (item_check ≥ 6901 AND  item_check ≤ 6902) OR 
        (item_check ≥ 7080 AND  item_check ≤ 7999) OR 
        (item_check ≥ 800 AND  item_check ≤ 4699) OR 
        (item_check ≥ 8006 AND  item_check ≤ 8007) OR 
        (item_check ≥ 8019 AND  item_check ≤ 8020) OR 
        (item_check ≥ 8058 AND  item_check ≤ 8058) OR 
        (item_check ≥ 8082 AND  item_check ≤ 8085) OR 
        (item_check ≥ 8143 AND  item_check ≤ 8150) OR 
        (item_check ≥ 9999 AND  item_check ≤ 9999)
            «Exempt» = "wholesale"
            endif
    endcase     
    
endif


///_____exemptions for MA______///
if toState = "MA"

    case which_branch contains "seeds"

        if (item_check ≥ 0 AND  item_check ≤ 4699) OR
        (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
        (item_check ≥ 5976 AND  item_check ≤ 5980) 
            «Exempt» = "wholesale"
                    endif

    case which_branch contains "trees"
        if (item_check ≥ 101 AND  item_check ≤ 422) OR 
        (item_check ≥ 432 AND  item_check ≤ 438) OR 
        (item_check ≥ 472 AND  item_check ≤ 477) OR 
        (item_check ≥ 491 AND  item_check ≤ 493) OR 
        (item_check ≥ 512 AND  item_check ≤ 512) OR 
        (item_check ≥ 515 AND  item_check ≤ 516) OR 
        (item_check ≥ 583 AND  item_check ≤ 614) OR 
        (item_check ≥ 744 AND  item_check ≤ 744) OR 
        (item_check ≥ 753 AND  item_check ≤ 753) OR 
        (item_check ≥ 755 AND  item_check ≤ 755) OR 
        (item_check ≥ 758 AND  item_check ≤ 758) OR 
        (item_check ≥ 760 AND  item_check ≤ 760) OR 
        (item_check ≥ 762 AND  item_check ≤ 763) OR 
        (item_check ≥ 801 AND  item_check ≤ 931)
            «Exempt» = "wholesale"
                endif

    case which_branch contains "ogs"
        if (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
        (item_check ≥ 6901 AND  item_check ≤ 6902) OR 
        (item_check ≥ 7080 AND  item_check ≤ 7999) OR 
        (item_check ≥ 8006 AND  item_check ≤ 8007) OR 
        (item_check ≥ 8019 AND  item_check ≤ 8020) OR 
        (item_check ≥ 8058 AND  item_check ≤ 8058) OR 
        (item_check ≥ 8082 AND  item_check ≤ 8085) OR 
        (item_check ≥ 8143 AND  item_check ≤ 8150) OR 
        (item_check ≥ 8155 AND  item_check ≤ 8186) OR 
        (item_check ≥ 8189 AND  item_check ≤ 8193) OR 
        (item_check ≥ 8198 AND  item_check ≤ 8317) OR 
        (item_check ≥ 8321 AND  item_check ≤ 8362) OR 
        (item_check ≥ 8369 AND  item_check ≤ 8369) OR 
        (item_check ≥ 8440 AND  item_check ≤ 8542) OR 
        (item_check ≥ 9390 AND  item_check ≤ 9395) OR 
        (item_check ≥ 9404 AND  item_check ≤ 9410) OR 
        (item_check ≥ 9999 AND  item_check ≤ 9999)
            «Exempt» = "wholesale"
                endif
    endcase
endif 

///____exemptions for MD_____///
if toState = "MD"

    case which_branch contains "seeds"
        if (item_check ≥ 0 AND  item_check ≤ 4699) OR 
        (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
        (item_check ≥ 5976 AND  item_check ≤ 5980)
            «Exempt» = "wholesale"
            endif
    
    case which_branch contains "ogs"
        if (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
        (item_check ≥ 6901 AND  item_check ≤ 6902) OR 
        (item_check ≥ 7080 AND  item_check ≤ 7999) OR 
        (item_check ≥ 8001 AND  item_check ≤ 8037) OR 
        (item_check ≥ 8043 AND  item_check ≤ 8060) OR 
        (item_check ≥ 8062 AND  item_check ≤ 8150) OR 
        (item_check ≥ 8153 AND  item_check ≤ 8193) OR 
        (item_check ≥ 8198 AND  item_check ≤ 8362) OR 
        (item_check ≥ 8369 AND  item_check ≤ 8369) OR 
        (item_check ≥ 8440 AND  item_check ≤ 8512) OR 
        (item_check ≥ 8666 AND  item_check ≤ 8711) OR 
        (item_check ≥ 8719 AND  item_check ≤ 8723) OR 
        (item_check ≥ 8726 AND  item_check ≤ 8768) OR 
        (item_check ≥ 9999 AND  item_check ≤ 9999)
            «Exempt» = "wholesale"
            endif 
    endcase
endif

///______Exemptions for MN______//
if toState = "MN"
    case which_branch contains "ogs"
        if (item_check ≥ 8143 AND  item_check ≤ 8144) OR 
        (item_check ≥ 8186 AND  item_check ≤ 8186) OR 
        (item_check ≥ 9388 AND  item_check ≤ 9442) OR 
        (item_check ≥ 9453 AND  item_check ≤ 9453) OR 
        (item_check ≥ 9999 AND  item_check ≤ 9999)
            «Exempt» = "wholesale"
                endif
    endcase
endif


///______Exemptions for NY____///
if toState = "NY"

    case which_branch contains "ogs"
        if (item_check ≥ 8193 AND  item_check ≤ 8193) OR 
        (item_check ≥ 9388 AND  item_check ≤ 9395) OR 
        (item_check ≥ 9404 AND  item_check ≤ 9433) OR 
        (item_check ≥ 9453 AND  item_check ≤ 9453) OR 
        (item_check ≥ 9999 AND  item_check ≤ 9999)
            «Exempt» = "wholesale"
                endif
    endcase 
endif


////_____Exemptions for RI____////
if toState = "RI"

    case which_branch contains "seeds"
        if (item_check ≥ 0 AND  item_check ≤ 797) OR 
        (item_check ≥ 800 AND  item_check ≤ 4699) OR 
        (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
        (item_check ≥ 5976 AND  item_check ≤ 5980) 
            «Exempt» = "wholesale"
            endif

    case which_branch contains "ogs"
        if (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
        (item_check ≥ 6901 AND  item_check ≤ 6902) OR 
        (item_check ≥ 7080 AND  item_check ≤ 7999) OR 
        (item_check ≥ 8007 AND  item_check ≤ 8007) OR 
        (item_check ≥ 8019 AND  item_check ≤ 8020) OR 
        (item_check ≥ 8058 AND  item_check ≤ 8058) OR 
        (item_check ≥ 8082 AND  item_check ≤ 8085) OR 
        (item_check ≥ 8143 AND  item_check ≤ 8150) OR 
        (item_check ≥ 8193 AND  item_check ≤ 8193) OR 
        (item_check ≥ 9388 AND  item_check ≤ 9395) OR 
        (item_check ≥ 9404 AND  item_check ≤ 9433) OR 
        (item_check ≥ 9453 AND  item_check ≤ 9453) OR 
        (item_check ≥ 9999 AND  item_check ≤ 9999)
            «Exempt» = "wholesale"
            endif
    endcase
endif


////______Exemptions for VT_____///
if toState = "VT"

    case which_branch contains "seeds"
        if (item_check ≥ 0 AND  item_check ≤ 797) OR 
        (item_check ≥ 800 AND  item_check ≤ 4699) OR 
        (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
        (item_check ≥ 5976 AND  item_check ≤ 5980) 
            «Exempt» = "wholesale"
            endif

    case which_branch contains "trees"
        if (item_check ≥ 101 AND  item_check ≤ 422) OR 
        (item_check ≥ 432 AND  item_check ≤ 438) OR 
        (item_check ≥ 472 AND  item_check ≤ 477) OR 
        (item_check ≥ 491 AND  item_check ≤ 493) OR 
        (item_check ≥ 512 AND  item_check ≤ 512) OR 
        (item_check ≥ 515 AND  item_check ≤ 516) OR 
        (item_check ≥ 583 AND  item_check ≤ 614) OR 
        (item_check ≥ 744 AND  item_check ≤ 744) OR 
        (item_check ≥ 753 AND  item_check ≤ 753) OR 
        (item_check ≥ 755 AND  item_check ≤ 755) OR 
        (item_check ≥ 758 AND  item_check ≤ 758) OR 
        (item_check ≥ 760 AND  item_check ≤ 760) OR 
        (item_check ≥ 762 AND  item_check ≤ 763) OR 
        (item_check ≥ 801 AND  item_check ≤ 931) 
        «Exempt» = "wholesale"
            endif
    
    case which_branch contains "ogs"
        if (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
        (item_check ≥ 6901 AND  item_check ≤ 6902) OR 
        (item_check ≥ 7080 AND  item_check ≤ 7999) OR 
        (item_check ≥ 8007 AND  item_check ≤ 8007) OR 
        (item_check ≥ 8019 AND  item_check ≤ 8020) OR 
        (item_check ≥ 8058 AND  item_check ≤ 8058) OR 
        (item_check ≥ 8082 AND  item_check ≤ 8085) OR 
        (item_check ≥ 8143 AND  item_check ≤ 8150) OR 
        (item_check ≥ 8193 AND  item_check ≤ 8193) OR 
        (item_check ≥ 8198 AND  item_check ≤ 8204) OR 
        (item_check ≥ 8440 AND  item_check ≤ 8557) OR 
        (item_check ≥ 9390 AND  item_check ≤ 9395) OR 
        (item_check ≥ 9404 AND  item_check ≤ 9433) OR 
        (item_check ≥ 9453 AND  item_check ≤ 9453) OR 
        (item_check ≥ 9999 AND  item_check ≤ 9999)
            «Exempt» = "wholesale"
            endif
    endcase
endif
___ ENDPROCEDURE CheckExemptions _______________________________________________

___ PROCEDURE FormattedOrderLine _______________________________________________
global prodID, itemDesc, 
itemQty, itemUnitPrice, 
discountEach, exemption

window TJSeeds

///GetDiscount to spread out among each line item

discountEach = (discountTotal / val(info("records")))
field «Discounts»
formulafill str(discountEach)


///____Export To TJExportermain file

///Fill other Variables
prodID = «Item»
itemQty = «Fill»
itemUnitPrice = «Price»
itemDesc = «Description»
exemption = «Exempt»


«Exported» = datestr(today())





___ ENDPROCEDURE FormattedOrderLine ____________________________________________

___ PROCEDURE (CommonFunctions) ________________________________________________

___ ENDPROCEDURE (CommonFunctions) _____________________________________________

___ PROCEDURE ExportMacros _____________________________________________________
local Dictionary1, ProcedureList
//this saves your procedures into a variable
exportallprocedures "", Dictionary1
clipboard()=Dictionary1

message "Macros are saved to your clipboard!"
___ ENDPROCEDURE ExportMacros __________________________________________________

___ PROCEDURE ImportMacros _____________________________________________________
local Dictionary1,Dictionary2, ProcedureList
Dictionary1=""
Dictionary1=clipboard()
yesno "Press yes to import all macros from clipboard"
if clipboard()="No"
stop
endif
//step one
importdictprocedures Dictionary1, Dictionary2
//changes the easy to read macros into a panorama readable file

 
//step 2
//this lets you load your changes back in from an editor and put them in
//copy your changed full procedure list back to your clipboard
//now comment out from step one to step 2
//run the procedure one step at a time to load the new list on your clipboard back in
//Dictionary2=clipboard()
loadallprocedures Dictionary2,ProcedureList
message ProcedureList //messages which procedures got changed

___ ENDPROCEDURE ImportMacros __________________________________________________

___ PROCEDURE Symbol Reference _________________________________________________
bigmessage "Option+7= ¶  [in some functions use chr(13)
Option+= ≠ [not equal to]
Option+\= « || Option+Shift+\= » [chevron]
Option+L= ¬ [tab]
Option+Z= Ω [lineitem or Omega]
Option+V= √ [checkmark]
Option+M= µ [nano]
Option+<or>= ≤or≥ [than or equal to]"


___ ENDPROCEDURE Symbol Reference ______________________________________________

___ PROCEDURE GetDBInfo ________________________________________________________
local DBChoice, vAnswer1, vClipHold

Message "This Procedure will give you the names of Fields, procedures, etc in the Database"
//The spaces are to make it look nicer on the text box
DBChoice="fields
forms
procedures
permanent
folder
level
autosave
fileglobals
filevariables
fieldtypes
records
selected
changes"
superchoicedialog DBChoice,vAnswer1,“caption="What Info Would You Like?"
captionheight=1”


vClipHold=dbinfo(vAnswer1,"")
bigmessage "Your clipboard now has the name(s) of "+str(vAnswer1)+"(s)"+¶+
"Preview: "+¶+str(vClipHold)
Clipboard()=vClipHold

___ ENDPROCEDURE GetDBInfo _____________________________________________________

___ PROCEDURE .AutomaticFY _____________________________________________________

    
global dateHold, dateMath, intYear, 
thisFYear,lastFYear,nextFYear,intMonth,fileDate

fileDate=val(striptonum(info("databasename")))
nextFYear=""
thisFYear=""
lastFYear=""

//get the date
dateHold = datepattern(today(),"mm/yyyy")

//gets the current month and year
intMonth = val(dateHold[1,"/"][1,-2])
intYear = val(dateHold["/",-1][2,-1])

//assigns FY numbers for years

case val(intMonth)>6
    nextFYear=str(intYear-1976)
    thisFYear=str(intYear-1977)
    lastFYear=str(intYear-1978)

case val(intMonth)<7
    nextFYear=str(intYear-1977)
    thisFYear=str(intYear-1978)
    lastFYear=str(intYear-1979)

endcase

//checks if this is an older file and needs older FYs
if fileDate ≤ val(lastFYear) and fileDate > 0
    nextFYear=str(fileDate+1)
    thisFYear=str(fileDate)
    lastFYear=str(fileDate-1)
endif

//tallmessage str(nextFYear)+¬+str(thisFYear)+¬+str(lastFYear)


/*

///////~~~~~~~
Programmer Notes
~~~~~~~~~//////////
The danger of this procedure is that come July 1st of the year, it will automatically set
to open the newest files of a non-numbered Panorama file. And if those don't exist, you're 
gonna see errors. Also, a non numbered Panorama file that needs to call older files shouldn't
use this macro



To use these variables please note the following Panorama syntax rules:


filenames using variables:
    can just concatenate as a string
    
    ex:
        
    openfile str(variable)+"filename" 


field calls using variables:
    best to be only one variable and nothing else
    must be surrounded by ( )
    
    ex:
    
    field (VariableFieldName)
    
do your math and/or concatenation into the variable before calling it
    VariableFieldName=str(variable)+"fieldname"
 
field (str(variable)+"fieldname") will work but can cause errors
    
for assignments to that variable'd field 
    use «» for "current field/current cell" 
    
    ex: 
   
    «» = "10"
  
    
*/

___ ENDPROCEDURE .AutomaticFY __________________________________________________

___ PROCEDURE Folders&FilesMacros ______________________________________________

//message "This Function is meant to get you information about the folders and path your files are in for Panorama"


global commList, commWanted, clipHoldComm, buttonChoice, numChoice

commList=""
commWanted=""
clipHoldComm=""
buttonChoice=""
numChoice=0

commList=¶+
    "1 - Copy Text of folderpath"
    +¶+¬+¬+¬+¬+¬+¬+
    "1 code -- folderpath(folder(""))"
    +¶+" "+¶+
    "2 - Copy list of All Files and Folders in this folder" 
    +¶+¬+¬+¬+¬+¬+¬+
    "2 code -- listfiles(folder(""),"")"
    +¶+" "+¶+
    "3 - Copy list of All Panorama files in this folder" 
    +¶+¬+¬+¬+¬+¬+¬+
    '3 code -- listfiles(folder(""),"????KASX")'
    +¶+" "+¶+
    "4 - Copy list of All Text files in this folder" 
    +¶+¬+¬+¬+¬+¬+¬+
    '4 code -- listfiles(folder(""),"TEXT????")'

/*

//NOTE: these quotation marks “” vs "" are called smart quotes
//you get them with opt+[ and opt+shift+[
//normally for superchoicedialogs, i would use curly brackets around title or caption
//but to have this be able to be written into new files from another macro, I had
//to use smart quotes

*/
superchoicedialog commList, commWanted, 
“Title="Get File/Folder/Path"
    Caption="1 - Copy ~~~~~~ gets you the data
        1 - Code ~~~~~~ gets you the formula"
    captionheight="2"
    buttons="Ok;Cancel"
    width="800"
    height="800"”
    

        clipHoldComm=commWanted
        numChoice=striptonum(clipHoldComm)[1,3]


if commWanted[1,12] notcontains "code"

    case numChoice="1"
        tallmessage "clipboard now has: "+¶+folderpath(folder(""))
        clipboard()=folderpath(folder(""))

    case numChoice="2"
        tallmessage "clipboard now has: "+¶+listfiles(folder(""),"")
        clipboard()=listfiles(folder(""),"")
    
    case numChoice="3"
        tallmessage "clipboard now has: "+¶+listfiles(folder(""),"????KASX")
        clipboard()=listfiles(folder(""),"????KASX")

    case numChoice="4"
        tallmessage "clipboard now has: "+¶+listfiles(folder(""),"TEXT????")
        clipboard()=listfiles(folder(""),"TEXT????")

    endcase
endif

if commWanted[1,12] contains "code"
    case numChoice="1"
    clipboard()='folderpath(folder(""))'
    tallmessage "clipboard now has: "+¶+'folderpath(folder(""))'

    case numChoice="2"
    clipboard()='listfiles(folder(""),"")'
    tallmessage "clipboard now has: "+¶+'listfiles(folder(""),"")'
    
    case numChoice="3"
        tallmessage "clipboard now has: "+¶+'listfiles(folder(""),"????KASX")'
        clipboard()='listfiles(folder(""),"????KASX")'

    case numChoice="4"
        tallmessage "clipboard now has: "+¶+'listfiles(folder(""),"TEXT????")'
        clipboard()='listfiles(folder(""),"TEXT????")'

    endcase
endif
    


___ ENDPROCEDURE Folders&FilesMacros ___________________________________________

___ PROCEDURE DesignSheetExportImport __________________________________________

global vdictionary, 
name, value, ImportExportChoicelist,
fileList,choiceMade,winChoice1,winChoice2,vOptions

/*
programmer's notes

i was testing using a variable for options as stated in the reference. it seems to work with vOptions below

also tested using a call to listfiles vs putting listfiles in a variable. both seem to work

as seen in other procedures in this file instead of using curly braces we are using smartquotes because "setproceduretext" for the AddMacros fuction wont work otherwise

also, options for superchoices and other customizable dialogs are very particular in 
their syntax

caption = "dafsdf" will allow the code to run, but will not show a caption
caption="dafsdf" will actually show the caption
*/


vOptions=“caption="Choose file to export Design Sheet from"”
choiceMade=""
fileList=listfiles(folder(""),"????KASX")


superchoicedialog fileList, choiceMade, vOptions

winChoice1=choiceMade

superchoicedialog fileList, choiceMade,
“caption="Choose file to export Design Sheet to"”

winChoice2=choiceMade

window (winChoice1)
    opendesignsheet
    vdictionary=""
    firstrecord

        loop
            setdictionaryvalue vdictionary, «Field Name», «Equation»
            downrecord
        until info("stopped")

window (winChoice2)
    opendesignsheet
    firstrecord

        loop
            field «Equation»
            «» = getdictionaryvalue(vdictionary, «Field Name»)
            downrecord
        until info("stopped")


___ ENDPROCEDURE DesignSheetExportImport _______________________________________

___ PROCEDURE .FileChecker _____________________________________________________
///____________________________________________________________________________________________________________________________________
///____________________________________________________________________________________________________________________________________
///________________________________This is the .FileChecker macro in GetMacros_________________________________________________________
///____________________________________________________________________________________________________________________________________
///____________________________________________________________________________________________________________________________________


local fileNeeded,folderArray,smallFolderArray,sizeCheck,
procList,sizeCheck,procNames,procDBs,mostRecentProc

///________________________EDITME_____________
//replace this with whatever file you're error checking
//----------------------//
fileNeeded="members"    //
//----------------------//


////_____Got the file, but it's not open?_______________
case info("files") notcontains fileNeeded and listfiles(folder(""),"????KASX") contains fileNeeded
openfile fileNeeded

///________Don't got the file?__________________
case listfiles(folder(""),"????KASX") notcontains fileNeeded


    procList=arraystrip(info("procedurestack"),¶)
    sizeCheck=arraysize(procList,¶)
        if sizeCheck>1
            procList=arrayrange(procList,2,sizeCheck,¶) //this is to exclude getting recursive info about this macro, especially while testing
        else
            procList=arraystrip(info("procedurestack"),¶)
        endif

    procNames=arraycolumn(procList,1,¶,¬)
    procDBs=arraycolumn(procList,2,¶,¬)
    mostRecentProc=array(procNames,1,¶) 
    folderArray=folderpath(folder(""))
    sizeCheck=arraysize(folderArray,":")
    smallFolderArray=arrayrange(folderArray,4,sizeCheck,":")

displaydata "Error:"
+¶+
"You are missing the '"+fileNeeded+
"' Panorama file in this folder 
and can't continue the '"+mostRecentProc+"' procedure without it. 
Please move a copy of '"+fileNeeded+
"' to the appropriate folder and try the procedure again"
+¶+¶+¶+
"folder you're currently running from is: "
+¶+
smallFolderArray
+¶+¶+¶+
"current Pan files in that folder are: "
+¶+
listfiles(folder(""),"????KASX")
+¶+¶+¶+
"Pressing 'Ok' will open the Finder to your current folder"
+¶+¶+
"Press 'Stop' will stop this procedure", “title="Missing File!!!!" captionwidth=900 size=17 height=500 width=800”
//___________________________
//note, the above are "smart quotes" option+[ and option+shift+[ 
//you can also use curley braces, but another program I run will break
//if this file has thos
//___________________________

revealinfinder folder(""),""
stop

///_______File is open, but not active?______
defaultcase
window fileNeeded

endcase

/*
Example:

You are missing the 'members' Panorama file in this folder 
and can't continue this procedure without it. Please move a copy of
'members' to the appropriate folder and try the procedure again


folder you're currently running from is: 
Desktop:Panorama:FY45 Panorama Projects:GetMacros:


current Pan files in that folder are: 
GetMacros
GetMacrosDL
GetMacros44


Pressing 'Ok' will open the Finder to your current folder

Press 'Stop' will stop this procedure
*/
___ ENDPROCEDURE .FileChecker __________________________________________________

___ PROCEDURE .GetErrorLog _____________________________________________________
///____________________________________________________________________________________________________________________________________
///____________________________________________________________________________________________________________________________________
///________________________________This is the .GetErrorLog macro in GetMacros_________________________________________________________
///____________________________________________________________________________________________________________________________________
///____________________________________________________________________________________________________________________________________
/*

This can be called to with a parameter of the 
info("error") statement to display the error, give
the user the opportunity to try again or continue 
despite the error.

Either way, it makes a log of the error and what procedures,
windows, files, and variables were in use. 

-Lunar 8-22

Syntax to call:

        if error
            call .GetErrorLog,info("error")
        endif

*/
///____________________________________________________________________________________________________________________________________
///____________________________________________________________________________________________________________________________________

fileglobal fileNeeded,folderArray,smallFolderArray,sizeCheck, procList, mostRecentProc, 
panFilesList,activeFiles,allvariables,procNames,procDBs,errorList, procText, procTextArray,
lineNum, procCount, usedvariables,printVariables,strippedText,getError,errorMsg,vDb,vProc,
activeWindows,DictNameToday

//this is to keep a log of the errors
permanent errorDictionary
    errorDictionary=errorDictionary
    if error
    errorDictionary=""
    endif

errorMsg=""

getError=str(parameter(1))
    if error //if there's no parameter given, or if info("error") is blank, then say "Unknown"
    getError="Unknown"
    endif

procList=arraystrip(info("procedurestack"),¶)
    if procList="" //sometimes, there's no info in the procedure stack, and this macro shoudl stop at this point
    message "Procedure Stack is Empty -L"
    stop
    endif
sizeCheck=arraysize(procList,¶)
    if sizeCheck>1
    procList=arrayrange(procList,2,sizeCheck,¶) //this is to exclude getting recursive info about this macro, especially while testing
    else
    procList=arraystrip(info("procedurestack"),¶)
    endif

procNames=arraycolumn(procList,1,¶,¬)
procDBs=arraycolumn(procList,2,¶,¬)
mostRecentProc=array(procNames,1,¶) 
folderArray=folderpath(folder(""))

///____________more readable filepath________________
;sizeCheck=arraysize(folderArray,":")
;smallFolderArray=arrayrange(folderArray,4,sizeCheck,":")
///__________________________________________________

panFilesList=listfiles(folder(""),"????KASX")
activeFiles=info("files")
activeWindows=info("windows")
allvariables="Global variables"+¶+¶+info("globalvariables")+¶+¶+"local variables"+¶+¶+info("localvariables")+¶+¶+"fileglobal variables"+¶+¶+info("filevariables")+¶+¶+"window variables"+¶+¶+info("windowvariables")

//____bugcheck_______
;displaydata procNames
;displaydata procDBs
//___________________

lineNum=1
procCount=arraysize(procNames,¶)
procTextArray=""

//_______build an array of the procedure text of all the last used procedures_____
/*
Notes: this kept breaking when I tried to use arrayfilters or arraybuilds, and apparently there's 
known issues with using local variables that throws an exception about the call() procedure
because its using a subroutine using EXECTUTE to do arrayfilters 

That being said, it kept breaking even after turning the variables global, so now it's a loop
*/
//________________________________________________________________________________

loop
    vDb=array(procDBs,lineNum,¶)
    vProc=array(procNames,lineNum,¶)
        getproceduretext vDb,vProc,procText
        procTextArray=vProc+¶+¶+procText+¶+procTextArray  //format: Name of Procedure, two returns, text from the proc, then the last thing added put on the end
    lineNum=lineNum+1
while lineNum<procCount


//_________________Make code into word array______________________//
/*
this function makes two arrays similar enough to compare to find out
which of the active variables was in the procedures that were recently called
gets rid of the most common characters in the text and replaces them with ; to give the other functions
a separator to work with

This was done because there's like 30 variables that are only Panorama's that also gets included in the INFO("xVARIABLE")
calls, and those aren't really useful for bugfixing procedures. 

//______________get out extra characters, but retrain spaces between words using a semicolon__________
note: there were also pipes '||' with curley brackets between them, but those break the SETPROCEDURETEXT statement, so I had to take them out of the "GetMacros" version
*/
strippedText=replacemultiple(procTextArray,
“.||?||!||,||;||:||-||_||(||)||[||]||"||'||+||¶||¬||/||=||*||" "|| ||”,
“;||;||;||;||;||;||;||;||;||;||;||;||;||;||;||;||;||;||;||;||;||;||”,
"||")

strippedText=stripchar(strippedText,"AZaz09;")
arraystrip strippedText,";"

//_____Change the format of the array into a ¶ one_______
strippedText=replace(strippedText,";",¶)
arraydeduplicate strippedText,strippedText,¶

//________get variablelist into a cleaner version_____
usedvariables=arraystrip(allvariables,¶)

//__________do a comparison for whats in both of them and put that in printVariables
arrayboth strippedText, usedvariables, ¶, printVariables

//_______Print Check_____
;displaydata printVariables


////____________Error Log____________________
/*
The short form of what gets displayed to the user specifically to be added to the 
errorDictionary. You can get this full log by calling 
DISPLAYDATA errorDictionary
*/
DictNameToday=superdatepattern(supernow(),"mm/dd/yy@", "hh:mm" )
setdictionaryvalue errorDictionary,DictNameToday, 
"Error: '"+mostRecentProc+"' created an error."
+¶+¶+
"ErrorCode: "+getError
+¶+¶+¶+
"folder in use: "
+¶+
folderArray
+¶+¶+¶+
"current Pan files in that folder are: "
+¶+
panFilesList
+¶+¶+¶+
"currently open files are: "
+¶+
activeFiles
+¶+¶+¶+
"currently open windows are: "
+¶+
activeWindows
+¶+¶+¶+
"last procedures run were"
+¶+
procList
+¶+¶+¶+
"text of non-design/form procedures:"
+¶+
procTextArray
+¶+¶+¶+
"variables used in last macros:"
+¶+
printVariables

///__________Future feature_____________
/*
Give the user instructions on what to do based on the error
*/
errorList="array of errors to give advice about"
//_______________________________________


////_____________ErrorDisplay for user________________________________________

displaydata "Error: '"+mostRecentProc+"' procedure/macro created an error."
+¶+¶+
"ErrorCode: "+getError
+¶+¶+
"Warning! If you click OK the macro will continue without fixing
the error. Proceed with caution, or click Stop instead."
+¶+¶+
"Click 'stop' to end the macro here and try what you were doing again"
+¶+¶+
"If the problem persists, use the 'COPY' button, paste this error in an e-mail 
and send it to: tech-support@fedcoseeds.com with a description of what happened



_______________________________________________________________________________"
+¶+¶+¶+
"---------------------------------------------------
THE FOLLOWING LINES ARE TO HELP WITH ERROR CHECKING
---------------------------------------------------"
+¶+¶+¶+
"folder in use: "
+¶+
folderArray
+¶+¶+¶+
"current Pan files in that folder are: "
+¶+
panFilesList
+¶+¶+¶+
"currently open files are: "
+¶+
activeFiles
+¶+¶+¶+
"currently open windows are: "
+¶+
activeWindows
+¶+¶+¶+
"last procedures run were"
+¶+
procList
+¶+¶+¶+
"text of non-design/form procedures:"
+¶+
procTextArray
+¶+¶+¶+
"variables used in last macros:"
+¶+
printVariables, 
“title="Error Capture Bot 3.0" 
captionwidth=900 
size=17 
height=500 
width=1000”



/*
//_________What this error looks like___________

Error: '.GetErrorLog' procedure/macro created an error.

ErrorCode: Unknown

Warning! If you click OK the macro will continue without fixing
the error. Proceed with caution, or click Stop instead.

Click 'stop' to end the macro here and try what you were doing again

If the problem persists, use the 'COPY' button, paste this error in an e-mail 
and send it to: tech-support@fedcoseeds.com with a description of what happened



_______________________________________________________________________________


---------------------------------------------------
THE FOLLOWING LINES ARE TO HELP WITH ERROR CHECKING
---------------------------------------------------


folder in use: 
LunarWindflower:Applications:Panorama:Panorama.app:Contents:MacOS:


current Pan files in that folder are: 
ProVUE Registration.pan


currently open files are: 
Untitled


currently open windows are: 
Untitled
Untitled:.GetErrorLog


last procedures run were
.GetErrorLog	Untitled		0


text of non-design/form procedures:
.GetErrorLog

The Text of the .GetErrorLog macro would be here, but I don't wanna double this file's
Length


variables used in last macros:
activeFiles
activeWindows
allvariables
DictNameToday
errorDictionary
errorList
errorMsg
fileNeeded
folderArray
getError
lineNum
mostRecentProc
panFilesList
printVariables
procCount
procDBs
procList
procNames
procText
procTextArray
sizeCheck
smallFolderArray
strippedText
usedvariables
vDb
vProc

*/

___ ENDPROCEDURE .GetErrorLog __________________________________________________

___ PROCEDURE SeeErrorLog ______________________________________________________

    displaydata errorDictionary

___ ENDPROCEDURE SeeErrorLog ___________________________________________________

___ PROCEDURE .WaitXSeconds ____________________________________________________
local start, end,secondsToWait

secondsToWait=5
start=now()
end=start+secondsToWait
loop
    nop
while now()≤end

//_____test timer____
;message end - start

___ ENDPROCEDURE .WaitXSeconds _________________________________________________

___ PROCEDURE GetWindowSize ____________________________________________________
global newrec, rectangle1,RecTop,RecLeft,RecHeight,RecWidth,whichWin,winList2

winList2=info("windows")
superchoicedialog winList2,whichWin,“caption="Which Window do you want the size of?"”
window (whichWin)
rectangle1=info("windowrectangle")
RecTop=rtop(rectangle1)
RecLeft=rleft(rectangle1)
RecHeight=rheight(rectangle1)
RecWidth=rwidth(rectangle1)

newrec=str(RecTop)+","+str(RecLeft)+","+str(RecHeight)+","+str(RecWidth)
message "You now have the Top, Left, Height, and Width of the window. You can use the setwindow command with these numbers"
clipboard()=newrec
//top,left,height,width


___ ENDPROCEDURE GetWindowSize _________________________________________________
