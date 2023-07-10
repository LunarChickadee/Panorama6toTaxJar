if tally_check contains "s"
    window TJexporter

    call SeedsImportSimple
endif

if tally_check contains "o"

    window TJexporter

    call OGSExportSimple
endif

if tally_check contains "w"

    window TJexporter

    call OGSWalkinExportSimple

endif

if tally_check contains "t"

    window TJexporter

    call TreesImportSimple

endif

    window TJexporter

    call CleanUpData

    call "Remove Exemptions"