___ PROCEDURE .CheckRequired ___________________________________________________
global requiredFields

requiredFields = "provider,transaction_id,transaction_date,to_state,to_zip,to_country,item_product_identifier,item_quantity,item_unit_price"

if requiredFields contains info("fieldname") AND («» = "" or zeroblank(«») = "")
    message "The field: "+info("fieldname")+" is required"
endif
___ ENDPROCEDURE .CheckRequired ________________________________________________

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

___ PROCEDURE .fillEquation ____________________________________________________
formulafill '.CheckRequired'
___ ENDPROCEDURE .fillEquation _________________________________________________

___ PROCEDURE (ImportFunctions) ________________________________________________

___ ENDPROCEDURE (ImportFunctions) _____________________________________________

___ PROCEDURE ImportTrees ______________________________________________________
global get_orders, date_range,  tree_tally, which_branch, 
files_open, order_line, TransactionID, TJExport
local start_date, end_date
permanent trees_last_date_imported

TJExporter = info("databasename")

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







//-----Find Date Range-----///

window tree_tally

select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date

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

openfile "TaxJarTreesTotaller"

if info('windows') notcontains "TaxJarTreesTotaller"
    message "Can't find TJTreesTotaller, fix that"
    stop
    endif

global TJTrees 

TJTrees = info("windowname")

extendedexpressionstack

loop

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

//---import loop ---///


window tree_tally

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

///_____Split apart orders, set exemptions, put in proper place on TJExporter_____///

///___Get the date in lines to start___///

global Order_line, PickSheet_line

Order_line = «Order»

//clipboard()=  replace(Order_line," ","!")

window TJTrees

//___Fills the trees Totaller and exemptions 
//___resets to first line of order
call ExtractOrderInfo


loop

    //____pulls the relevant data out of the trees line
    call FormattedOrderLine

    window TJExporter

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
    «item_unit_price» = str(itemUnitPrice)
    «exemption_type» = exemption 

    window TJTrees

    downrecord

until info("stopped")


window tree_tally

downrecord

until info("stopped")


window TJExporter

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
trees_last_date_imported = datepattern(today(),"YYYY-MM-DD")
___ ENDPROCEDURE ImportTrees ___________________________________________________

___ PROCEDURE ExemptItems ______________________________________________________
global has_exemptions

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
___ ENDPROCEDURE ExemptItems ___________________________________________________

___ PROCEDURE test _____________________________________________________________
///____Get list of currently open tallies and prompt the user to get the rile files open___///

global available_files, tally_files, totaller_files,file_num, list_size, loop_counter  

file_num = 0

tally_files = ""

available_files = ""

available_files = listfiles(folder(""),"????KASX")
tally_files = available_files
totaller_files = ""
list_size = arraysize(tally_files,¶)



loop_counter = 0
loop
 file_num = file_num + 1
 loop_counter = loop_counter +1
 
     if array(tally_files, file_num, ¶) contains "totaller"
        //message array(tally_files, file_num, ¶)
        totaller_files = arrayinsert(totaller_files,1,1,¶)
        totaller_files = arraychange(totaller_files,array(tally_files, file_num, ¶), 1,¶)
        totaller_files = arraystrip(totaller_files,¶)
        endif
    
    if array(tally_files, file_num, ¶) notcontains "tally" 
        tally_files = arraydelete(tally_files, file_num, 1, ¶)
        file_num = file_num - 1  // Adjust the index after deletion
    endif
  
        
    if val(array(tally_files, file_num, ¶)) < 10
        tally_files = arraydelete(tally_files, file_num, 1, ¶)
        file_num = file_num - 1  // Adjust the index after deletion
    endif     
    

until loop_counter = list_size



___ ENDPROCEDURE test __________________________________________________________

___ PROCEDURE ImportSeeds ______________________________________________________
global get_orders, date_range,  seeds_tally, which_branch, 
files_open, order_line, TransactionID, TJExporter
local start_date, end_date
permanent seeds_last_date_imported

TJExporter = info("databasename")

//___change this for future files? 
which_branch = "seedstally"

if info("windows") notcontains str(which_branch)
    message "You need a "+which_branch+" Open"
    stop
    endif

files_open = info("windows")

seeds_tally = array(info("windows"), arraysearch( files_open, "*"+which_branch+"*", 1, ¶ ), ¶)
//message seeds_tally


define seeds_last_date_imported, datepattern(today(),"YYYY-MM-DD")

date_range = ""




//-------Get Date Range------//
GetDate:
gettext "Last Date: "+seeds_last_date_imported+" Next starting date?", start_date

start_date = date(start_date)

yesno "Start with "+ datepattern(start_date, "YYYY-MM-DD")+"?"
    if clipboard()="No"
        goto GetDate
        endif
        
gettext "Ending date?", end_date
end_date = date(end_date)

yesno "End with "+ datepattern(end_date, "YYYY-MM-DD")+"?"
    if clipboard()="No"
        goto GetDate
        endif

//-----End Get Date Range----//


//-----Select Date Range-----///

window seeds_tally

select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date

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
        
noshow

openfile "TaxJarSeedsTotaller"

if info('windows') notcontains "TaxJarSeedsTotaller"
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
debug
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
    «item_unit_price» = str(itemUnitPrice)
    «exemption_type» = exemption 

    window TJseeds

    downrecord

until info("stopped")
debug


window seeds_tally

downrecord

until info("stopped")


window TJExporter

endnoshow

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
___ ENDPROCEDURE ImportSeeds ___________________________________________________

___ PROCEDURE CleanUpData ______________________________________________________
save

//____Round the Discounts
field «item_discount»

formulafill money(val(«»))


//___get periods out of transactionID
field «transaction_id»
formulafill replace(«»,".","_")

//___Fix any nonalphanum in item description____
field «item_description»

global bad_characters, good_characters

bad_characters = "’,',-,/,\,*,™,®,sub "
good_characters = ",, , , , ,,,"

formulafill replacemultiple( «», bad_characters,good_characters, ",")
___ ENDPROCEDURE CleanUpData ___________________________________________________

___ PROCEDURE CheckData ________________________________________________________
field transaction_id
groupup

field total_shipping

propagate

field total_sales_tax

propagate

field item_unit_price

total

outlinelevel "1"

global price_check, ship_check, tax_check

lastrecord
price_check = «»

firstrecord

field total_shipping

ship_check = «»

loop

ship_check = «»+","+ship_check

downrecord

until info("stopped")

firstrecord

field total_sales_tax

tax_check = «»

loop

tax_check = «»+","+tax_check

downrecord

until info("stopped")

ship_check = arraynumerictotal(ship_check,",")

tax_check = arraynumerictotal(tax_check,",")


clipboard()= "Total Sales: "+
str(price_check)+"

Total shipping: " + 
str(ship_check)+" 



Total Taxes: " + 
str(tax_check)

bigmessage clipboard()

outlinelevel "Data"

removeallsummaries











___ ENDPROCEDURE CheckData _____________________________________________________

___ PROCEDURE GroupLoop ________________________________________________________
///______Get Seedstally name________

global get_orders, date_range,  seeds_tally, which_branch, 
files_open, order_line, TransactionID, group_list, full_group_list

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



//displaydata group_list

selectwithin arraycontains( group_list, str(OrderNo)[1,"."][1,-2], "," ) or group_list contains str(OrderNo)

arrayselectedbuild full_group_list, ¶, "", str(OrderNo)

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








        










___ ENDPROCEDURE GroupLoop _____________________________________________________

___ PROCEDURE .SetImportDate ___________________________________________________


global start_date, end_date, month_input, date_format


///NEeds to get list of tally files open, and if they're not open, prompt the user to get them open

date_input = ""
month_input = ""

gettext "Which month are you doing taxes for?",month_input

//if not january, do this, else, take the year back one value

if month_input notcontains "dec"
    date_format = month_input+" 1 "+str(yearvalue(today()))

    date_format = date(date_format)

    start_date = month1st(date_format)

    end_date = month_input+" "+str(monthlength(date_format))+" "+str(yearvalue(today()))
    end_date = date(end_date)

else
        date_format = month_input+" 1 "+str(yearvalue(today())-1)

    date_format = date(date_format)

    start_date = month1st(date_format)

    end_date = month_input+" "+str(monthlength(date_format))+" "+str(yearvalue(today())-1)
    end_date = date(end_date)
endif



window "45seedstally-winter"

selectall

select date(datestr(«EntryDate»)) ≥ start_date AND date(datestr(«EntryDate»)) ≤ end_date

///_____since taxes are always looking backward, we need to make sure that if it's 
///______looking for junes taxes that the user knows they need a different file

if info("empty") and monthvalue(start_date) = 6
    message "this range occurs on the fiscal year previous, please open the files that will have june's data, seedstally will close, procedure will stop"
    closefile
    stop
    endif
if info("empty") and monthvalue(start_date) ≠ 6
    message "nothing in that range for Seeds, file will close and procedure will continue"
    closefile
    endif

___ ENDPROCEDURE .SetImportDate ________________________________________________

___ PROCEDURE .SetFileNames ____________________________________________________
///____Get list of currently open tallies and prompt the user to get the rile files open___///

global available_files, tally_files, totaller_files,file_num, list_size, loop_counter  

file_num = 0

tally_files = ""

available_files = ""

available_files = listfiles(folder(""),"????KASX")
tally_files = available_files
totaller_files = ""
list_size = arraysize(tally_files,¶)



loop_counter = 0
loop
 file_num = file_num + 1
 loop_counter = loop_counter +1
 
     if array(tally_files, file_num, ¶) contains "totaller"
        //message array(tally_files, file_num, ¶)
        totaller_files = arrayinsert(totaller_files,1,1,¶)
        totaller_files = arraychange(totaller_files,array(tally_files, file_num, ¶), 1,¶)
        totaller_files = arraystrip(totaller_files,¶)
        endif
    
    if array(tally_files, file_num, ¶) notcontains "tally" 
        tally_files = arraydelete(tally_files, file_num, 1, ¶)
        file_num = file_num - 1  // Adjust the index after deletion
    endif
  
        
    if val(array(tally_files, file_num, ¶)) < 10
        tally_files = arraydelete(tally_files, file_num, 1, ¶)
        file_num = file_num - 1  // Adjust the index after deletion
    endif     
    

until loop_counter = list_size


///Set Files

global TJseeds, TJtrees, TJogs, seeds_tally, trees_tally, ogs_tally, TJexporter

seeds_tally = array(tally_files, arraysearch(tally_files, "*seeds*",1,¶),¶)
trees_tally = array(tally_files, arraysearch(tally_files, "*trees*",1,¶),¶)
ogs_tally = array(tally_files, arraysearch(tally_files, "*ogs*",1,¶),¶)

TJseeds = array(totaller_files, arraysearch(tally_files, "*seeds*",1,¶),¶)
TJtrees = array(totaller_files, arraysearch(tally_files, "*trees*",1,¶),¶)
TJogs = array(totaller_files, arraysearch(tally_files, "*ogs*",1,¶),¶)  
//note, ogs needs an addition to initialize next to wayfair to add taxjar exception

debug
TJexporter = "TaxJarExporter"


if info("windows") notcontains seeds_tally and seeds_tally ≠ ""
openfile seeds_tally
endif

if info("windows") notcontains trees_tally and trees_tally ≠ ""
openfile trees_tally
endif

if info("windows") notcontains ogs_tally and ogs_tally ≠ ""
openfile ogs_tally
endif



___ ENDPROCEDURE .SetFileNames _________________________________________________

___ PROCEDURE .Initialize ______________________________________________________
call .AutomaticFY
___ ENDPROCEDURE .Initialize ___________________________________________________
