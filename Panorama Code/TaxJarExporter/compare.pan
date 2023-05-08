///______Get Seedstally name________

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
////_____________//////


window seeds_tally

//Get List of Groups

global group_list

firstrecord

find str(OrderNo) contains "."

    if info("found")

    group_list = str(int(val(«»)))

        endif

loop

    next

    if info('found')

    group_list = str(int(val(«»)))+","+group_list

    endif

until (not info("found"))

arraydeduplicate group_list,group_list, ","

//displaydata group_list


global chosen_order_num, counter, total_discount, item_list


///Change back to 1 after testing
counter = 5

firstrecord 

//from that list, find orders that contain that number
//loop

chosen_order_num = array(group_list, counter, ",")

find str(«OrderNo») contains chosen_order_num

////______Get D

total_discount  = «VolDisc» + «MemDisc»











