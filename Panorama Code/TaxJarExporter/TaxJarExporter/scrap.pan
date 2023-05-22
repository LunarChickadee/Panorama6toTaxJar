///____Get list of currently open tallies and prompt the user to get the rile files open___///

global available_files, tally_files, totaller_files,file_num

file_num = 0

tally_files = ""

available_files = ""

available_files = listfiles(folder(""),"????KASX")
tally_files = available_files
loop
    file_num = file_num+1
    if available_files,(file_num),¶ notcontains "tally"
    tally_files = arraydelete(tally_files,file_num,1,¶)
until file_num = arraysize(available_files)

displaydata tally_files

