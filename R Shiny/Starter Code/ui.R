fluidPage(
  textInput(inputId="textInput",label="Enter text",value="",placeholder="Enter text here"),
  numericInput(inputId="numeric",label="Enter a number",value=5,min=1,max=10,step=1),
  checkboxInput(inputId="checkbox",label="Check or uncheck",value=FALSE),
  checkboxGroupInput(inputId="multi checkbox",label="Check or uncheck",choices=c("Choice 1","Choice 2","Choice 3")),
  selectInput(inputId="select",label="Select",choices=c("Choice 1","Choice 2","Choice 3"),multiple=FALSE),
  sliderInput(inputId="slider",label="Select a number",min=1,max=10,value=5,step=2),
  radioButtons(inputId="radio",label="Select one",choices=c("Choice 1","Choice 2","Choice 3")),
  dateInput(inputId="date",label="Select a date",value="2019-01-01"),
  dateRangeInput(inputId="dateRange",label="Select a range",start="2019-01-01",end="2019-01-31")
  )

fluidPage(
  textInput(inputId="name",label="Enter your name:",placeholder="John Smith"),
  numericInput(inputId="age",label="Enter your age:",value=30),
  dateInput(inputId="birthday",label="Select your birthday:"),
  selectInput(inputId="gender",label="Choose your sex",choices=c("Male","Female")),
  sliderInput(inputId="favNum",label="Select your favorite number:",min=1,max=100,step=1,value=50)
  
  
)



