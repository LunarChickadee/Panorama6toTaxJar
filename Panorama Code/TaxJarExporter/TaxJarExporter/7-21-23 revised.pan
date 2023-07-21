___ PROCEDURE .CheckRequired ___________________________________________________

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

___ ENDPROCEDURE test __________________________________________________________

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

___ PROCEDURE .SetImportDate ___________________________________________________


global start_date, end_date, month_input, date_format, use_last_year

use_last_year = 0


///NEeds to get list of tally files open, and if they're not open, prompt the user to get them open

month_input = ""

gettext "Which month are you doing taxes for?",month_input

//if not january, do this, else, take the year back one value

if month_input notcontains "dec"
    date_format = month_input+" 1 "+str(yearvalue(today()))

    date_format = date(date_format)

    start_date = month1st(date_format)
    //real end date
    end_date = month_input+" "+str(monthlength(date_format))+" "+str(yearvalue(today()))
    
      
     //test end date for smallers subsets
   //end_date = "4-4-2023"
   
   
    end_date = date(end_date)
else
        date_format = month_input+" 1 "+str(yearvalue(today())-1)

    date_format = date(date_format)

    start_date = month1st(date_format)

    end_date = month_input+" "+str(monthlength(date_format))+" "+str(yearvalue(today())-1)
    end_date = date(end_date)
    
     
endif





///_____since taxes are always looking backward, we need to make sure that if it's 
///______looking for junes taxes that the user knows they need a different file


    call .GetTallyFiles
          
rtn


___ ENDPROCEDURE .SetImportDate ________________________________________________

___ PROCEDURE .SetFileNames ____________________________________________________
///____Get list of currently open tallies and prompt the user to get the rile files open___///

global available_files, tally_files, totaller_files,file_num, list_size, 
loop_counter,TJseeds, TJtrees, TJogs, seeds_tally, trees_tally, ogs_tally, TJexporter, ogs_walkin

//call .GetTallyFiles

debug
///Set Files



seeds_tally = "seedstallyDelinked"
trees_tally = "treestallyDelinked"
ogs_tally = "ogstallyDelinked"
ogs_walkin = "ogswalkinDelinked"


//displaydata totaller_files
TJseeds = "TaxJarSeedsTotaller"
TJtrees = "TaxJarTreesTotaller"
TJogs = "TaxJarOGSTotaller"

TJexporter = "TaxJarSimpleExport"


window TJexporter
___ ENDPROCEDURE .SetFileNames _________________________________________________

___ PROCEDURE .Initialize ______________________________________________________
global states_w_shipping_tax

states_w_shipping_tax = "AR,CT,DC,GA,HI,IL,IN,KS,KY,MN,MS,NE,NJ,NM,NY,NC,ND,OH,PA,RI,SC,SD,TN,TX,VT,WA,WV,WI"

call .SetFileNames

yesno "Are you importing new numbers?"

if clipboard()="No"

stop

endif

deleteall

call .SetImportDate

window TJexporter

call .SetSelections

speak "Ready for imports"
___ ENDPROCEDURE .Initialize ___________________________________________________

___ PROCEDURE .SetFileNamesLastYear ____________________________________________


___ ENDPROCEDURE .SetFileNamesLastYear _________________________________________

___ PROCEDURE .SetSelections ___________________________________________________
global active_tally_data

active_tally_data = "s,t,o"


////_______Seeds Setup
openfile seeds_tally

gosheet

    window seeds_tally

    selectall

    select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date

    if info("empty") and monthvalue(start_date) ≠ 6
        message "nothing in that range for Seeds, file will close and procedure will continue"
        closefile
        active_tally_data = replace(active_tally_data,"s","")
    else 
        removeunselected
        endif 
save
openfile trees_tally

gosheet

    window trees_tally

    selectall

    select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date

    if info("empty") and monthvalue(start_date) ≠ 6
        message "nothing in that range for Trees, file will close and procedure will continue"
        closefile
        active_tally_data = replace(active_tally_data,"t","")
    else
        removeunselected
        endif
    save
openfile ogs_tally 

gosheet

    window ogs_tally

    selectall

    select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date

    removeunselected



    if info("empty") and monthvalue(start_date) ≠ 6
        message "nothing in that range for OGS, file will close and procedure will continue"
        closefile
        active_tally_data = replace(active_tally_data,"o","")
    else
        removeunselected
        endif
save
arraystrip active_tally_data, ","



openfile ogs_tally 

gosheet

    window ogs_walkin

    selectall

    select date(datestr(«Date»)) ≥ start_date AND date(datestr(«Date»)) ≤ end_date

    removeunselected



    if info("empty") and monthvalue(start_date) ≠ 6
        message "nothing in that range for OGS, file will close and procedure will continue"
        closefile
        active_tally_data = replace(active_tally_data,"w","")
    else
        removeunselected
        endif
save
arraystrip active_tally_data, ","

openfile ogs_walkin

gosheet
___ ENDPROCEDURE .SetSelections ________________________________________________

___ PROCEDURE FormattedOrderLine _______________________________________________

___ ENDPROCEDURE FormattedOrderLine ____________________________________________

___ PROCEDURE ImportAll ________________________________________________________
extendedexpressionstack

//

window TJexporter

if active_tally_data contains "s"
call SeedsGroups //this call needs a rtn if there's no info found for a group search


window TJexporter

debug



call ImportSeeds


debug
endif

save


window TJexporter
if active_tally_data contains "o"
call OGSGroups


debug

save

window TJexporter
call ImportOGS
endif

save

if active_tally_data contains "t"
window TJexporter
call ImportTrees
endif

window TJexporter



showpage

call .FindLikelyErrors

___ ENDPROCEDURE ImportAll _____________________________________________________

___ PROCEDURE reset ____________________________________________________________
call .Initialize
___ ENDPROCEDURE reset _________________________________________________________

___ PROCEDURE ExtractOrderInfo _________________________________________________
message "wrong Extract!!!!"
___ ENDPROCEDURE ExtractOrderInfo ______________________________________________

___ PROCEDURE .GetTallyFiles ___________________________________________________
global linked_folder, all_files, windows_start, seeds_file, tally_check
local filename,folder,type

all_files = listfiles(folder(""),"")
tally_check = ""

linked_folder = array(all_files,arraysearch(all_files, "*LinkedTallies*",1,¶),¶)

windows_start = info("windows")
//displaydata linked_folder

///_____select all the tallies you want to get data from, then based on those
///__________selections, open, syncronize, save, close, then upload to offline database
yesno "Do you have a seeds tally?"
if clipboard()="Yes"
tally_check = tally_check +¬+"s"
global seeds_folder, seeds_file, seeds_type
openfiledialog seeds_folder, seeds_file,seeds_type,""
endif

yesno "Do you have a trees tally?"
if clipboard()="Yes"
tally_check = tally_check+¬+"t"
global trees_folder, trees_file, trees_type
openfiledialog trees_folder, trees_file,trees_type,""
endif 

yesno "Do you have an ogs tally?"
if clipboard()="Yes"
tally_check = tally_check+¬+"o"
global ogs_folder, ogs_file, ogs_type
openfiledialog ogs_folder, ogs_file,ogs_type,""
endif


yesno "Do you have an ogs walkin?"
if clipboard()="Yes"
tally_check = tally_check+¬+"w"
global ogs_walkin_folder, ogs_walkin_file, ogs_walkin_type
openfiledialog ogs_walkin_folder, ogs_walkin_file,ogs_walkin_type,""
endif

arraystrip tally_check, ¬

if tally_check contains "s"
opensecret folderpath(seeds_folder)+seeds_file
window (seeds_file)+":Secret"
synchronize
save
closefile
openfile "seedstallyDelinked"
openfile "&&"+folderpath(seeds_folder)+seeds_file
endif

if tally_check contains "t"
opensecret folderpath(trees_folder)+trees_file
window (trees_file)+":Secret"
synchronize
save
closefile
openfile "treestallyDelinked"
openfile "&&"+folderpath(trees_folder)+trees_file
endif


if tally_check contains "o"
opensecret folderpath(ogs_folder)+ogs_file
window (ogs_file)+":Secret"
synchronize
save
closefile
openfile "ogstallyDelinked"
openfile "&&"+folderpath(ogs_folder)+ogs_file
endif

if tally_check contains "w"
opensecret folderpath(ogs_walkin_folder)+ogs_walkin_file
window (ogs_walkin_file)+":Secret"
synchronize
save
closefile
openfile "ogswalkinDelinked"
openfile "&&"+folderpath(ogs_walkin_folder)+ogs_walkin_file
endif






___ ENDPROCEDURE .GetTallyFiles ________________________________________________

___ PROCEDURE .FindLikelyErrors ________________________________________________
////______find likely errors______///
select val(item_quantity) ≠ 0
    removeunselected


select provider = "" OR
transaction_id = "" OR 
transaction_date = "" OR 
to_state = "" OR 
to_zip = "" OR 
to_country = "" OR
item_product_identifier = "" OR 
item_quantity = 0 OR
item_unit_price = 0

if (not info("empty"))
    message "Please fix these records with issues on required fields"
    endif

___ ENDPROCEDURE .FindLikelyErrors _____________________________________________

___ PROCEDURE CheckSelectedTotal _______________________________________________
global running_total, line_multiply

running_total = 0
firstrecord

loop
line_multiply = val(item_quantity) * val(item_unit_price)

running_total = running_total+line_multiply
downrecord

until info("stopped")

displaydata running_total


___ ENDPROCEDURE CheckSelectedTotal ____________________________________________

___ PROCEDURE checkSelectedOrderNums ___________________________________________
global order_no_list

arrayselectedbuild order_no_list, ¶, "", array(transaction_id,4,"_")

arraydeduplicate order_no_list, order_no_list, ¶
arraystrip order_no_list, ¶

displaydata order_no_list
___ ENDPROCEDURE checkSelectedOrderNums ________________________________________

___ PROCEDURE FixOGSOrders _____________________________________________________
global not_blank_eight, not_blank_one, cancelled_orders

window "ogstallyDelinked"

call OrderLengths


////________get the single tab orders out

select one_list notcontains str(OrderNo)
if info("found")

removeunselected
endif 

///______get all zero orders out

select eight_list notcontains str(OrderNo)
if info("found")
removeunselected
endif

select Notes1 notmatch "*cancel*" and 
OrderComments notmatch "*empty*" and
striptoalpha(«Original Order») notmatch "*j*" and
striptoalpha(«Original Order») ≠ "" and 
«Original Order» notcontains "complete"

removeunselected


___ ENDPROCEDURE FixOGSOrders __________________________________________________

___ PROCEDURE TestOGS __________________________________________________________
global get_orders, date_range,  which_branch, 
files_open, order_line, TransactionID, check_overflow_count
permanent seeds_last_date_imported

check_overflow_count = 0
extendedexpressionstack 
//noshow

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
    

    total_order = «AdjTotal» //or OrderTotal?

    //AdjTotal = «AdjTotal» - Discounts
    //«TaxedAmount» not sure hwat this is for 
    //taxed amount shows how much of the order was taxable

    //__Set untaxed batch___

    itemUnitPrice = ?(«TaxedAmount» > 0, «TaxedAmount», «AdjTotal»)

    if TaxableBool = False()
        exemption = "wholesale"

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

        non_taxable_order = «AdjTotal» - TaxedAmount
        case non_taxable_order > 0.50
            untaxed_items = True()
        defaultcase
            untaxed_items = False()
        endcase 
        
        
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
            «item_product_identifier» = "777777"
            «item_description» = "Batch of Seed Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax

            if untaxed_items = True()
                copyrecord
                pasterecord
                «item_product_identifier» = "777778"
                «item_unit_price» = non_taxable_order
                «exemption_type» = "wholesale"
                «item_sales_tax» = 0
                «item_description» = "Batch of Exempt Seed Product"
            endif

            ////____need to add a record with the non-taxable part of orders
                //___use a copy/pasterecord and just change whats needed to get the total sales correct



            debug

    endif



    window seeds_tally

    Exported = "Yes"

    save

    downrecord

until info("stopped") 




window TJexporter

call CleanUpData
endnoshow


speak "Seeds Import is complete"


//-----NOTE------//
/////////after import has succeeded, last import date needs to change
seeds_last_date_imported = datepattern(today(),"YYYY-MM-DD")


___ ENDPROCEDURE TestOGS _______________________________________________________

___ PROCEDURE OrdersImported ___________________________________________________
global trans_id_ref

firstrecord
trans_id_ref = ""
loop

trans_id_ref = «transaction_id»["-_",-1][2,-1]+","+trans_id_ref

downrecord

until info("stopped")

arraystrip trans_id_ref, ","



___ ENDPROCEDURE OrdersImported ________________________________________________

___ PROCEDURE GetTotalSold _____________________________________________________
global taxable_total, mather
firstrecord
noshow
mather = 0
taxable_total = 0
loop

mather = float(item_unit_price)*val(item_quantity)
taxable_total = taxable_total + mather

downrecord
until info("stopped")
endnoshow
showpage

displaydata taxable_total

___ ENDPROCEDURE GetTotalSold __________________________________________________

___ PROCEDURE GetShippingTotals ________________________________________________
global shipping_total, mather
firstrecord
noshow
mather = 0
shipping_total = 0
loop

mather = val(total_shipping)
shipping_total = shipping_total + mather

downrecord
until info("stopped")
endnoshow
showpage
showpage

displaydata shipping_total

___ ENDPROCEDURE GetShippingTotals _____________________________________________

___ PROCEDURE OpenSimply _______________________________________________________
openplain
___ ENDPROCEDURE OpenSimply ____________________________________________________

___ PROCEDURE (Individual Imports) _____________________________________________

___ ENDPROCEDURE (Individual Imports) __________________________________________

___ PROCEDURE SeedsGroups ______________________________________________________
///______Get Seedstally name________

global get_orders, date_range, which_branch, 
files_open, order_line, TransactionID, group_list, full_group_list

group_list = ""

full_group_list = ""

openfile seeds_tally


window seeds_tally



select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date
noshow


//___this is for taxes
which_branch = "seedstally"



//_________Get List of completed group orders


firstrecord

find str(OrderNo) contains "." and «Status» contains "Com"

    if info("found")

    group_list = str(int(val(«OrderNo»)))
    
    else
        rtn

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

//debug

////_______________________________////

////______import Parents and Children loop_______////

//initialize the window

openfile "TaxJarSeedsTotaller"

if info('windows') notcontains "TaxJarSeedsTotaller"
    message "Can't find TJseedsTotaller, fix that"
    stop
    endif



//_____

window seeds_tally

firstrecord

extendedexpressionstack

global discountTotal, totalShipping,totalSalesTax,Order_line
            
            Order_line = ""

DoAgain:

noshow
//__loop through parents and children
loop

window seeds_tally
    
        ////_________TaxJar SPecific______////
        //---start taxjar import loop ---///

        //---import loop ---///
        window seeds_tally

        global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
        totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal


        ///----Set Transcation ID------//
        TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«FillDate»))))+"_"+"seeds"+"_"+str(int(OrderNo))


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
    

      if str(OrderNo) contains "." 

                Order_line = "" 
        ////___get children's info____////
        loop
            ///_____Split apart orders, set exemptions, put in proper place on TJexporter_____//


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
    endif

window seeds_tally

until info("eof")

select full_group_list notcontains str(«OrderNo»)

removeunselected
endnoshow

window "TaxJarExporter"

call CleanUpData

speak "seeds groups finished"
___ ENDPROCEDURE SeedsGroups ___________________________________________________

___ PROCEDURE ImportSeeds ______________________________________________________
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

selectwithin str(OrderNo) notcontains "."


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
            
            
window TJseeds
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

save

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


___ ENDPROCEDURE ImportSeeds ___________________________________________________

___ PROCEDURE OGSGroups ________________________________________________________
///______Get ogstally name________

global get_orders, date_range, order_line, TransactionID, ogs_group_list, ogs_full_group_list

ogs_group_list = ""

openfile ogs_tally


window ogs_tally



select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date

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

//debug



//displaydata ogs_group_list

selectwithin arraycontains( ogs_group_list, str(OrderNo)[1,"."][1,-2], "," ) or ogs_group_list contains str(OrderNo)

arrayselectedbuild ogs_full_group_list, ¶, "", str(OrderNo)

//debug

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
    
    ////_________TaxJar SPecific______////
    //---start taxjar import loop ---///

    //---import loop ---///
    window ogs_tally

    global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
    totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal


    ///----Set Transcation ID------//
    TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«FillDate»))))+"_"+"ogs"+"_"+str(int(OrderNo))

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
    
    

    if str(OrderNo) contains "." 

    Order_line = "" 

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
        
        //debug

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
//debug
window ogs_tally

until info("eof")
endnoshow



___ ENDPROCEDURE OGSGroups _____________________________________________________

___ PROCEDURE ImportOGS ________________________________________________________
global get_orders, date_range, which_branch, 
files_open, order_line, TransactionID
permanent ogs_last_date_imported

///Call FixOGSOrders

///make this call OGSGroups????????
//_______________________________________Ω

openfile ogs_tally

window ogs_tally



select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date

selectwithin ogs_full_group_list notcontains str(«OrderNo»)


//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2

which_branch = "ogstally"

showpage

firstrecord

global import_count

import_count = val(info("records"))


//noshow



loop

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

//---import loop ---///


window ogs_tally

global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal

toCountry=""
///----Set Transcation ID------//
TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«FillDate»))))+"_"+"ogs"+"_"+str(OrderNo)


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

window TJogs

//___Fills the seeds Totaller and exemptions 
//___resets to first line of order

call ExtractOrderInfo


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

    window TJogs

    downrecord

until info("stopped")



window ogs_tally

downrecord

until info("stopped")


window TJexporter

//endnoshow

showpage

//debug

//call CleanUpData


//-----NOTE------//
/////////after import has succeeded, last import date needs to change
ogs_last_date_imported = datepattern(today(),"YYYY-MM-DD")

speak "OGS has finishes!!!!!!!"
___ ENDPROCEDURE ImportOGS _____________________________________________________

___ PROCEDURE ImportTrees ______________________________________________________
global get_orders, date_range, which_branch, 
files_open, order_line, TransactionID, TJExport
permanent trees_last_date_imported


define trees_last_date_imported, datepattern(today(),"YYYY-MM-DD")

date_range = ""


openfile "TaxJarTreesTotaller"

openfile trees_tally

//noshow
//-----Find Date Range-----///

window trees_tally

select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date

//Get completed orders only
selectwithin «Status» = "Com"

selectwithin length(«PickSheet») > 2

showpage

firstrecord

global import_count

import_count = val(info("records"))



extendedexpressionstack

loop

////_________TaxJar SPecific______////
//---start taxjar import loop ---///

//---import loop ---///


window trees_tally

global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal


///----Set Transcation ID------//
TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«FillDate»))))+"_"+"trees"+"_"+str(OrderNo)


///----Is Order or Refund----//
// transactionType = //_____formula for figuring out if something is an order or a refund____///


//Trees orders are all going to be under "Order"

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

///_____Split apart orders, set exemptions, put in proper place on TJexporter_____///

///___Get the date in lines to start___///

global Order_line, PickSheet_line

Order_line = «Order»

//clipboard()=  replace(Order_line," ","!")

window TJtrees

//___Fills the trees Totaller and exemptions 
//___resets to first line of order
call ExtractOrderInfo


loop

    //____pulls the relevant data out of the trees line
    call FormattedOrderLine

    window TJexporter

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
    «item_unit_price» = itemUnitPrice
    «exemption_type» = exemption 

    window TJtrees

    downrecord

until info("stopped")


window trees_tally

downrecord

until info("stopped")


window TJexporter


//Cleanup zeros and blanks

loop
    find item_quantity = "" or val(item_quantity) = 0
        if info("found")
            deleterecord
        endif
until (not info("found"))

//endnoshow

//-----NOTE------//
/////////after import has succeeded, last import date needs to change
trees_last_date_imported = datepattern(today(),"YYYY-MM-DD")

speak "Imports are finished"
___ ENDPROCEDURE ImportTrees ___________________________________________________

___ PROCEDURE CleanUpData ______________________________________________________
save

selectall



//___get periods out of transactionID
field «transaction_id»
formulafill replace(«»,".","_")

//___Fix any nonalphanum in item description____
field «item_description»

global bad_characters, good_characters

bad_characters = "’,',-,/,\,*,™,®,sub, "
good_characters = ",, , , , ,,,"

field to_name

loop

formulafill ascii96(«»)
//formulafill replacemultiple( «», bad_characters,good_characters, ",")

right

until info("fieldname") = "from_street"

local vCanada
vCanada="NL
PE
NS
NB
QC
ON
MB
SK
AB
BC
YT
NT
NU"

select vCanada contains to_state
if (not info("empty"))
    field to_country
    formulafill "CA"
    endif
    
 /*   
select item_unit_price > 0.01
    removeunselected
 */
___ ENDPROCEDURE CleanUpData ___________________________________________________

___ PROCEDURE RemoveSeedsGroups ________________________________________________
window "seedstallyDelinked"

select full_group_list notcontains str(OrderNo)

removeunselected


___ ENDPROCEDURE RemoveSeedsGroups _____________________________________________

___ PROCEDURE CheckAmounts _____________________________________________________
field transaction_id

groupup

  
___ ENDPROCEDURE CheckAmounts __________________________________________________

___ PROCEDURE SelectOrdersFromTallyList ________________________________________
selectwithin selected_orders notcontains «transaction_id»
___ ENDPROCEDURE SelectOrdersFromTallyList _____________________________________

___ PROCEDURE (SimpleImport) ___________________________________________________

___ ENDPROCEDURE (SimpleImport) ________________________________________________

___ PROCEDURE SeedsImportSimple ________________________________________________
global get_orders, date_range,  which_branch, 
files_open, order_line, TransactionID, check_overflow_count
permanent seeds_last_date_imported, time_start, time_end

time_start = now()

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


//Get completed orders only
selectwithin «Status» = "Com"

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
    

    total_order = «AdjTotal» //or OrderTotal?

    //AdjTotal = «AdjTotal» - Discounts
    //«TaxedAmount» not sure hwat this is for 
    //taxed amount shows how much of the order was taxable

    //__Set untaxed batch___


    if TaxableBool = False()
        exemption = "wholesale"

    itemUnitPrice = «AdjTotal»

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

        non_taxable_order = «AdjTotal» - «TaxedAmount»

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
            «item_product_identifier» = "777777"
            «item_description» = "Batch of Seed Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax

            if untaxed_items = True()
                copyrecord
                pasterecord
                «item_product_identifier» = "777778"
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
___ ENDPROCEDURE SeedsImportSimple _____________________________________________

___ PROCEDURE TreesImportSimple ________________________________________________
global get_orders, date_range,  which_branch, 
files_open, order_line, TransactionID, check_overflow_count
permanent trees_last_date_imported, time_start, time_end



check_overflow_count = 0
extendedexpressionstack 
noshow

//______Gets to the right data ____///
define trees_last_date_imported, datepattern(today(),"YYYY-MM-DD")

date_range = ""

which_branch = "treestally"

openfile trees_tally
//-----Select Date Range-----///

window trees_tally

select date(datestr(«FillDate»)) ≥ start_date AND date(datestr(«FillDate»)) ≤ end_date


//Get completed orders only
selectwithin «Status» = "Com"

selectwithin OrderNo = int(OrderNo)

firstrecord

 global transactionType, format_Date, toName, toStreet, toCity,toState, toZip, toCountry, totalShipping,
    totalSalesTax, productID,productDescription, itemQuantity, itemUnitPrice, OrderExempt, TaxableBool, discountTotal,
    exemption, total_order, non_taxable_order, untaxed_items

loop

    ////_________TaxJar SPecific______////
    //---start taxjar import loop ---///

    //---import loop ---///


    window trees_tally



    ///----Set Transcation ID------//
    TransactionID = "pan"+"_"+str(yearvalue(date(datestr(«FillDate»))))+"_"+"trees"+"_"+str(OrderNo)


    ///----Is Order or Refund----//
    // transactionType = //_____formula for figuring out if something is an order or a refund____///


    //trees orders are all going to be under "Order"

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

    //____trees does sell to canada 
    //+++++++
    ///______
    ///Make sure to set the logic for this for trees and possibly OGS
    toCountry = "US"

    ///___Set if order is Taxable_____
    //trees
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

    
    ///____set the needed info from your trees tally
    

    total_order = «AdjTotal» //or OrderTotal?

    //AdjTotal = «AdjTotal» - Discounts
    //«TaxedAmount» not sure hwat this is for 
    //taxed amount shows how much of the order was taxable

    //__Set untaxed batch___


    if TaxableBool = False()
        exemption = "wholesale"

    itemUnitPrice = «AdjTotal»

        window TJexporter
            

            addrecord

            ////Set all the proper Fields for each trees line from the TJtrees file

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
            «item_product_identifier» = "444448"
            «item_description» = "Batch of Exempt tree Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax

    else
        
        exemption = ""

        itemUnitPrice = «TaxedAmount»

        non_taxable_order = «AdjTotal» - «TaxedAmount»

        if non_taxable_order > 0.50
            untaxed_items = True()
        else 
            untaxed_items = False()
        endif 
        
        
        window TJexporter
            

            addrecord

            ////Set all the proper Fields for each trees line from the TJtrees file

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
            «item_product_identifier» = "444444"
            «item_description» = "Batch of tree Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax

            if untaxed_items = True()
                copyrecord
                pasterecord
                «item_product_identifier» = "444448"
                «item_unit_price» = non_taxable_order
                «exemption_type» = "wholesale"
                «item_sales_tax» = 0
                «item_description» = "Batch of Exempt tree Product"
            endif

            ////____need to add a record with the non-taxable part of orders
                //___use a copy/pasterecord and just change whats needed to get the total sales correct



            //debug

    endif



    window trees_tally

    Exported = "Yes"

    save

    downrecord

until info("stopped") 




window TJexporter

endnoshow


speak "trees Import is complete"


//-----NOTE------//
/////////after import has succeeded, last import date needs to change
trees_last_date_imported = datepattern(today(),"YYYY-MM-DD")


time_end = now()


normalexpressionstack

//displaydata (time_end - time_start)/60
___ ENDPROCEDURE TreesImportSimple _____________________________________________

___ PROCEDURE OGSExportSimple __________________________________________________
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



//Get completed orders only
selectwithin «Status» = "Com"

debug

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

    //AdjTotal = «AdjTotal» - Discounts
    //«TaxedAmount» not sure hwat this is for 
    //taxed amount shows how much of the order was taxable

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
            
            «total_sales_tax» = totalSalesTax
            «total_shipping» = totalShipping
            //«item_discount» = discountTotal/2


            //Other Info
            «item_product_identifier» = "333333"
            «item_description» = "Batch of ogs Product"
            «item_quantity» = 1
            «item_unit_price» = itemUnitPrice
            «exemption_type» = exemption 
            «item_sales_tax» = totalSalesTax





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