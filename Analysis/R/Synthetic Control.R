install.packages("haven")
library(haven)
middle <- read_dta("middle_r_data.dta")
elementary <- read_dta("elementary_r_data.dta")
install.packages("Synth")
library(Synth)

---------

elementary$BLAOutofSchoolSuspensionrat <- as.numeric(elementary$BLAOutofSchoolSuspensionrat)
elementary$ECDmathpercentageofproficenc <- as.numeric(elementary$ECDmathpercentageofproficenc)
elementary$LEPmathpercentageofproficenc <- as.numeric(elementary$LEPmathpercentageofproficenc)
elementary$blackmathpercentageofprofice <- as.numeric(elementary$blackmathpercentageofprofice)
elementary <- as.data.frame(elementary)
elementary$SchoolName <- tolower(elementary$SchoolName)
elementary$SchoolName[105] <- "madison park academy tk-5"
elementary$SchoolName[81] <- "martin luther king jr. elementary"
elementary$SchoolName[82] <- "martin luther king jr. elementary"

dataprep.out<-
  dataprep(
    foo = elementary,
    predictors = c("BLAOutofSchoolSuspensionrat", "ECDmathpercentageofproficenc"),
    predictors.op = "mean",
    dependent = "blackmathpercentageofprofice",
    unit.variable = "SchoolID",
    time.variable = "year",
    special.predictors = list(
      list("blackmathpercentageofprofice", c(2011, 2013), "mean")
    ),
    treatment.identifier = 62805004308,
    controls.identifier = c( 62805004238, 62805004239, 62805004241, 62805004243, 62805004245, 62805004249, 62805004251, 62805004260,
                             62805004261, 62805004264 ,62805004266 ,62805004269, 62805004273, 62805004276, 62805004277, 62805004280,
                             62805004287, 62805004289, 62805004294 ,62805004296, 62805004297, 62805004306, 62805004307, 62805004310,
                             62805004314, 62805004316 ,62805011556 ,62805011558, 62805011559, 62805011977, 62805012057, 62805012058,
                             62805012059
                             
    ),
    time.predictors.prior = c(2011, 2013),
    time.optimize.ssr = c(2011, 2013),
    unit.names.variable = "SchoolName",
    time.plot = c(2011,2013,2015,2017)
  )
synth.out <- synth(dataprep.out)
gaps<- dataprep.out$Y1plot-(
  dataprep.out$Y0plot%*%synth.out$solution.w
) ; gaps
synth.tables <- synth.tab(
  dataprep.res = dataprep.out,
  synth.res = synth.out)
print(synth.tables)
path.plot(dataprep.res = dataprep.out,synth.res = synth.out, tr.intake=2015, Ylab = c("black math percentage of proficiency"), Xlab = "Year", Legend.position = c("bottomleft"))  
x <- c(2016,2014,2014,2016)
y <- c(100, 100, 0, 0)
polygon(x,y,col=rgb(1, 0, 0,0.5))

----------
middle$BLAOutofSchoolSuspensionrat <- as.numeric(middle$BLAOutofSchoolSuspensionrat)
middle$ECDmathpercentageofproficenc <- as.numeric(middle$ECDmathpercentageofproficenc)
middle$LEPmathpercentageofproficenc <- as.numeric(middle$LEPmathpercentageofproficenc)
middle$blackmathpercentageofprofice <- as.numeric(middle$blackmathpercentageofprofice)
middle <- as.data.frame(middle)
middle$SchoolName <- tolower(middle$SchoolName)
middle$SchoolName[13] <- "madison park academy 6-12"
dataprep.out<-
  dataprep(
    foo = middle,
    predictors = c("BLAOutofSchoolSuspensionrat", "ECDmathpercentageofproficenc", "LEPmathpercentageofproficenc"),
    predictors.op = "mean",
    dependent = "blackmathpercentageofprofice",
    unit.variable = "SchoolID",
    time.variable = "year",
    special.predictors = list(
      list("blackmathpercentageofprofice", c(2011, 2013), "mean")
    ),
    treatment.identifier = 62805004303,
    controls.identifier = c(62805004242, 62805004250, 62805004263, 62805004278, 62805004299,  62805004312,
                            62805004323, 62805011907, 62805011909, 62805011961, 62805012027
    ),
    time.predictors.prior = c(2011, 2013),
    time.optimize.ssr = c(2011, 2013),
    unit.names.variable = "SchoolName",
    time.plot = c(2011,2013,2015,2017)
  )
synth.out <- synth(dataprep.out)
synth.tables <- synth.tab(
  dataprep.res = dataprep.out,
  synth.res = synth.out)
print(synth.tables)
path.plot(dataprep.res = dataprep.out,synth.res = synth.out, Ylab = c("black math percentage of proficiency"), Xlab = "Year", Legend.position = c("bottomright"))  
abline(v = 2015, col="black", lwd=3, lty=3)

library(stargazer)
stargazer(synth.tables$tab.pred)
stargazer(synth.tables$tab.w)

high <- read_dta("high_r_data.dta")
high$BLAOutofSchoolSuspensionrat <- as.numeric(high$BLAOutofSchoolSuspensionrat)
high$ECDmathpercentageofproficenc <- as.numeric(high$ECDmathpercentageofproficenc)
high$LEPmathpercentageofproficenc <- as.numeric(high$LEPmathpercentageofproficenc)
high$blackmathpercentageofprofice <- as.numeric(high$blackmathpercentageofprofice)
high <- as.data.frame(high)
high$SchoolName <- tolower(high$SchoolName)
high$SchoolName[9] <- "mcclymonds high"
dataprep.out<-
  dataprep(
    foo = high,
    predictors = c("BLAOutofSchoolSuspensionrat", "ECDmathpercentageofproficenc", "BlackGrade912DropoutRate"),
    predictors.op = "mean",
    dependent = "blackmathpercentageofprofice",
    unit.variable = "SchoolID",
    time.variable = "year",
    special.predictors = list(
      list("blackmathpercentageofprofice", c(2011, 2013), "mean")
    ),
    treatment.identifier = 62805011555,
    controls.identifier = c(62805008676, 62805011350, 62805011920
    ),
    time.predictors.prior = c(2011, 2013),
    time.optimize.ssr = c(2011, 2013),
    unit.names.variable = "SchoolName",
    time.plot = c(2011,2013,2015,2017)
  )

dataprep.out<-
  dataprep(
    foo = high,
    predictors = c("BLAOutofSchoolSuspensionrat", "ECDmathpercentageofproficenc"),
    predictors.op = "mean",
    dependent = "BlackGrade912DropoutRate",
    unit.variable = "SchoolID",
    time.variable = "year",
    special.predictors = list(
      list("BlackGrade912DropoutRate", 2011, "mean"),
      list("BlackGrade912DropoutRate", 2013, "mean")
    ),
    treatment.identifier = 62805011555,
    controls.identifier = c(62805008676, 62805011350, 62805011920
    ),
    time.predictors.prior = c(2011, 2013),
    time.optimize.ssr = c(2011, 2013),
    unit.names.variable = "SchoolName",
    time.plot = c(2011,2013,2015,2017)
  )





synth.out <- synth(dataprep.out)
synth.tables <- synth.tab(
  dataprep.res = dataprep.out,
  synth.res = synth.out)
print(synth.tables)
path.plot(dataprep.res = dataprep.out,synth.res = synth.out, Ylab = c("black math percentage of proficiency"), Xlab = "Year")
abline(v = 2015, col="black", lwd=3, lty=3)
