install.packages("elasticnet")
library(elasticnet)
data(diabetes)

diabetes_train = diabetes[1:320,]
diabetes_test = diabetes[321:442,]
attach(diabetes_train)

object1 <- enet(diabetes_train$x,diabetes_train$y,lambda=0)
object2 <- enet(diabetes_train$x,diabetes_train$y,lambda=1)
object3 <- enet(diabetes_train$x,diabetes_train$y,lambda=0.5,max.steps=50)
detach(diabetes_train)

attach(diabetes_test)
sink("~/Model_example3.txt")
predict(object1, diabetes_test$x)
predict(object2, diabetes_test$x)
predict(object3, diabetes_test$x)
sink()

pdf("~/RPlots_example3.pdf")
plot(object1)
plot(object2)
plot(object3)
dev.off()