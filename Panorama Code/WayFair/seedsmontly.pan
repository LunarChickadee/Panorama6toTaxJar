local seedsselected
select OrderNo = int(OrderNo)
seedsselected=info("selected")
;selectwithin FillDate ≥ month1st((month1st(today())-1)) and FillDate < month1st(today()) 
;   and Status contains "com" 
selectwithin Status contains "com"
;if info("selected")=seedsselected
;beep
;stop
;endif
//selectwithin arraycontains(ztaxstates,TaxState,",")

arrayselectedbuild raya,¶,"", "Seeds"+¬+str(OrderNo)+¬+Taxable+¬+TaxState+¬+Cit+¬+pattern(Z,"#####")+¬+¬+str(TaxRate)+¬+str(StateRate)+¬+
str(CountyRate)+¬+str(CityRate)+¬+str(SpecialRate)+¬+str(«$Shipping»)+¬+str(AdjTotal)+¬+str(TaxedAmount)+¬+str(SalesTax)+¬+datepattern(FillDate,"Month YYYY")+¬+¬+
str(StateTax)+¬+str(CountyTax)+¬+str(CityTax)+¬+str(SpecialTax)+¬+str(OrderTotal)
    clipboard()=raya
    ;stop
 openfile "WayfairSalesTax"
 openfile "+@raya"
;call "monthlytotals/t"

arrayselectedbuild raya,¶,"", "Seeds"+¬+
str(OrderNo)+¬+
Taxable+¬+
TaxState+¬+Cit+¬+pattern(Z,"#####")+¬+¬+str(TaxRate)+¬+str(StateRate)+¬+
str(CountyRate)+¬+str(CityRate)+¬+str(SpecialRate)+¬+
str(«$Shipping»)+¬+
str(AdjTotal)+¬+
str(TaxedAmount)+¬+
str(SalesTax)+¬+
datepattern(FillDate,"Month YYYY")+¬+¬+
str(StateTax)+¬+
str(CountyTax)+¬+
str(CityTax)+¬+
str(SpecialTax)+¬
+str(OrderTotal)

We need 
Subtotal for the total order 
AdjustedTotal for 


OrderTotal = 

TaxedAmount = 