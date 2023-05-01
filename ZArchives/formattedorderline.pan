global prodID, itemDesc, 
itemQty, itemUnitPrice, 
discountEach, exemption

window TJTrees

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




