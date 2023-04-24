global has_exemptions


////You need to make it so that the large seed ranges only trigger if it's a seed order
///or set it up by branch for the ifs/cases


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
item_check = striptonum(«Item»)

case toState = "CT"
    if (item_check ≥ 0 AND  item_check ≤ 797) OR 
    (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
    (item_check ≥ 5976 AND  item_check ≤ 5980) OR 
    (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
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
        
    else
        rtn
    endif

case toState = "MA"
   if (item_check ≥ 0 AND  item_check ≤ 4699) OR 
   (item_check ≥ 101 AND  item_check ≤ 422) OR 
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
   (item_check ≥ 801 AND  item_check ≤ 931) OR 
   (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
   (item_check ≥ 5976 AND  item_check ≤ 5980) OR 
   (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
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
        
    else
        rtn
    endif


case toState = "MD"
   if (item_check ≥ 0 AND  item_check ≤ 4699) OR 
   (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
   (item_check ≥ 5976 AND  item_check ≤ 5980) OR 
   (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
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
        
    else
        rtn
    endif

case toState = "MN"
    if (item_check ≥ 8143 AND  item_check ≤ 8144) OR 
    (item_check ≥ 8186 AND  item_check ≤ 8186) OR 
    (item_check ≥ 9388 AND  item_check ≤ 9442) OR 
    (item_check ≥ 9453 AND  item_check ≤ 9453) OR 
    (item_check ≥ 9999 AND  item_check ≤ 9999)

    «Exempt» = "wholesale"
        
    else
        rtn
    endif


case toState = "NY"
    if (item_check ≥ 8193 AND  item_check ≤ 8193) OR 
    (item_check ≥ 9388 AND  item_check ≤ 9395) OR 
    (item_check ≥ 9404 AND  item_check ≤ 9433) OR 
    (item_check ≥ 9453 AND  item_check ≤ 9453) OR 
    (item_check ≥ 9999 AND  item_check ≤ 9999)

    «Exempt» = "wholesale"
        
    else
        rtn
    endif

case toState = "RI"
    if (item_check ≥ 0 AND  item_check ≤ 797) OR 
    (item_check ≥ 800 AND  item_check ≤ 4699) OR 
    (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
    (item_check ≥ 5976 AND  item_check ≤ 5980) OR 
    (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
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
        
    else
        rtn
    endif


    

    case toState = "VT"
    if (item_check ≥ 0 AND  item_check ≤ 797) OR 
    (item_check ≥ 101 AND  item_check ≤ 422) OR 
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
    (item_check ≥ 800 AND  item_check ≤ 4699) OR 
    (item_check ≥ 801 AND  item_check ≤ 931) OR 
    (item_check ≥ 5932 AND  item_check ≤ 5942) OR 
    (item_check ≥ 5976 AND  item_check ≤ 5980) OR 
    (item_check ≥ 6221 AND  item_check ≤ 6236) OR 
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
        
    else
        rtn
    endif

endcase