

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
