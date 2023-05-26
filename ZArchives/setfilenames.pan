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
    
    if val(array(tally_files, file_num, ¶)) ≠ val(thisFYear)
      tally_files = arraydelete(tally_files, file_num, 1, ¶)
        file_num = file_num - 1  // Adjust the index after deletion
        endif     
    

until loop_counter = list_size+1


///Set Files

global TJseeds, TJtrees, TJogs, seeds_tally, trees_tally, ogs_tally, TJexporter

seeds_tally = array(tally_files, arraysearch(tally_files, "*seeds*",1,¶),¶)
trees_tally = array(tally_files, arraysearch(tally_files, "*trees*",1,¶),¶)
ogs_tally = array(tally_files, arraysearch(tally_files, "*ogs*",1,¶),¶)

TJseeds = array(totaller_files, arraysearch(tally_files, "*seeds*",1,¶),¶)
TJtrees = array(totaller_files, arraysearch(tally_files, "*trees*",1,¶),¶)
TJogs = array(totaller_files, arraysearch(tally_files, "*ogs*",1,¶),¶)  
//note, ogs needs an addition to initialize next to wayfair to add taxjar exception


TJexporter = "TaxJarExporter"


case use_last_year = 0

    if info("windows") notcontains seeds_tally and seeds_tally ≠ ""
        openfile seeds_tally
        endif

    if info("windows") notcontains trees_tally and trees_tally ≠ ""
        openfile trees_tally
        endif

    if info("windows") notcontains ogs_tally and ogs_tally ≠ ""
        openfile ogs_tally
        endif

case use_last_year = -1

    ///Set Files to last year

    seeds_tally = array(tally_files, arraysearch(tally_files, "*seeds*",1,¶),¶)
    seeds_tally = replace(seeds_tally, thisFYear, lastFYear )
    trees_tally = array(tally_files, arraysearch(tally_files, "*trees*",1,¶),¶)
    trees_tally = replace(trees_tally, thisFYear, lastFYear )
    ogs_tally = array(tally_files, arraysearch(tally_files, "*ogs*",1,¶),¶)
    ogs_tally = replace(ogs_tally, thisFYear, lastFYear )

message available_files
///_______This will likley break with the seeds summer and seeds winter split, so be mindful___///
    if info("windows") notcontains seeds_tally and available_files contains seeds_tally
        openfile seeds_tally
        endif

    if info("windows") notcontains trees_tally and available_files contains trees_tally
        openfile trees_tally
        endif

    if info("windows") notcontains ogs_tally and available_files contains ogs_tally
        openfile ogs_tally
        endif

endcase

openfile TJseeds
openfile TJtrees
openfile TJogs

window TJexporter