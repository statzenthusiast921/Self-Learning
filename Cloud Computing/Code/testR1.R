dat = read.csv("~/Data.csv")
group <- gl(2, 10, 20, labels = c("Control","Treatment"))
weight <- c(dat$Control, dat$Treatment)
lm.D9 <- lm(weight ~ group)
lm.D90 <- lm(weight ~ group - 1) # omitting intercept

sink(file="~/Model.txt")
anova(lm.D9)
summary(lm.D90)
sink()

out = data.frame(Fitted = lm.D9$fitted.values, Residuals = lm.D9$residuals)
write.csv(out, file="~/Results.csv")

pdf("~/RPlots_example2.pdf")
plot(lm.D9)
dev.off()