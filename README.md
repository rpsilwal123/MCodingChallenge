# Code Challenge

##The assignment
Write an application that:
- Allows the user to add a zip code to a table / list
- Allows the user to select a zip code and see the current temperature using the OpenWeatherMap API
- Shows the location on a map with the current temperature in the map pin
- Allows the user to set a preference for ºC or ºF


#### Additional functionality (Optional)
- Allow the user to select `Current Location` that automatically adds the current zip code to the list
- Persist the user’s list of cities
- Show a 5-day list of high and low temperatures
- Post a tweet about the current weather (for iOS, use Apple’s Social Framework; for Android, use an Implicit Intent)
- Take a photo that overlays the current temperature on a corner
- Save the photo to the user’s library
- Share the photo with Facebook (for iOS, use Apple’s Social Framework; for Android, use an Implicit Intent)
- Show other weather information (e.g. cloudiness, humidity)

##
##

### How to use and What to expect from this app

- I am using two different openweathermap Apis. 
    - To get One particular location current weather report. (First page where you can see userInput box and a button). when you add a valid zip code. I made a network call in order to retrive the particular location's weather and display on the view along the map with drop pin with title of the place and current temperature. 
        - This is the landing page of the app. There is segment control which changes between degree Fahrenheit and degree Celcius. 
        - There is a sharing button on the bottom right cornor on this page where you can share twitter post about the current weather details and share photo to your facebook account. 
        - You can take a photo on an iOS device (iPhone or iPad) or choose one from the photo library and make that photo as a blurred background on the page. 
        - Whenever you enter the zip code and search using search button, your location is saved on an array by the help of NSUserDefaults and persisted. Later when you tap on searchbox, you search history along with city and country is shown on the tableView. 
        - If you want to delete those address, you can swipe right that particuler cell and delete. It will be deleted from persisted array and also on the NSUserDefaults.


 2) To get current users location weather report for 7 days in a custom tableview with tableViewHeader of customized date format. This is a Second page when you click "current weather" on navigation bar on firstViewcontroller.