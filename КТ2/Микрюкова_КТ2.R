library("xlsx")
Table<-read.xlsx("problems_1.xlsx",1)

library(rpivotTable)
rpivotTable::rpivotTable(
  Table,
  rows="AdmArea",
  cols="Year",
  aggregatorName = "Average",
  vals="TotalAmount",
  exclusions=list(Year = list("2020","2021","Год"))
)
rpivotTable::rpivotTable(
  Table,
  rows="Month",
  aggregatorName = "Sum",
  vals="TotalAmount",
  sorters = '
  function(attr) {
    var sortAs = $.pivotUtilities.sortAs;
    if (attr == "Month") { 
      return sortAs(["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]);
    } 
  }',
  inclusions=list(Year = list("2021"))
)
rpivotTable::rpivotTable(
  Table,
  rows="AdmArea",
  cols="Year",
  aggregatorName = "Average",
  vals="TotalAmount",
  exclusions=list(Year= list("Год"))
)
Data<-data.frame(Table$AdmArea[2:length(Table$AdmArea)], Table$Month[2:length(Table$Month)],
                 as.numeric(Table$Year[2:length(Table$Year)]),
                 as.numeric(Table$TotalAmount[2:length(Table$TotalAmount)]))
colnames(Data)<-c("AdmArea","Month","Year","TotalAmount")
centr <- subset(Data,Data$AdmArea == "Центральный административный округ")

Current <-data.frame()
for (i in c(2016:2021))  Current<-rbind(Current,mean(centr$TotalAmount[centr$Year==i]))
Current<-data.frame(Current,c(2016:2021))
colnames(Current)<-c("Total","Year")
DAvg<-rpivotTable::rpivotTable(
  centr,
  rows="Year",
  vals="TotalAmount", 
  aggregatorName = "Average"
)
result<-data.frame()
for (i in Current$Year)
{
  j<-as.vector(centr$Month[(centr$Year==i) & (centr$TotalAmount>=Current$Total[Current$Year==i])])
  print(c(i,j))
  for (k in j) {result<-rbind(result, c(i,k), stringsAsFactors=FALSE)}
}
colnames(result)<-c("Year","Month")

result<-data.frame(as.numeric(result$Year),as.character(result$Month),stringsAsFactors = FALSE)
colnames(result)<-c("Year","Month")
save(centr,result,file = "res.dat")


