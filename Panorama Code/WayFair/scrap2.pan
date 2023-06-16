
"Seeds"+¬+
str(OrderNo)+¬+
Taxable+¬+
TaxState+¬+
Cit+¬+
pattern(Z,"#####")+¬+
¬+
str(TaxRate)+¬+
str(StateRate)+¬+
str(CountyRate)+¬+
str(CityRate)+¬+
str(SpecialRate)+¬+
str(«$Shipping»)+¬+
str(AdjTotal)+¬+ /// becomes ItemTotal
str(TaxedAmount)+¬+  ///becomes taxable total 
str(SalesTax)+¬+ // becomes tallytax
datepattern(FillDate,"Month YYYY")+¬+
¬+
str(StateTax)+¬+
str(CountyTax)+¬+
str(CityTax)+¬+
str(SpecialTax)+¬+
str(OrderTotal)