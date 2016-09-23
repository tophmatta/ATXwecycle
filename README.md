# ATXwecycle
## What problem am I solving?
I created this app to provide everyone with a mobile tool to determine
when to bring their recycling bin to the curb while on a bi-weekly schedule. I figured I
wasn't the only person who couldn't keep track, therefore I thought it 
would be a fun problem to solve while also helping out the community.

The City of Austin aggregates their recycling schedules and the associated addresses publicly using Socrata Open Data API (SODA), which
is the backend I use to bounce my HTTP requests off of to configure the user's schedule. The user can either manually enter in there address or use reverse geocode location feature
if they are at their home at the time to allow for a quicker, more automated initial setup.

## Technologies used:
  * Core Location
  * NSUserDefaults, NSDate, NSCalendar (getting current calendar of user then tracking date)
  * UIPickerView
  * Auto Layout w/ multiplier usage (different screen sizes)
  * CocoaPods: Alamofire, SwiftyJSON (making API calls and handling JSON data)
  
## I had fun:
  * delving deeper into the Core Location framework & being able to use reverse geocode location to improve the UX of the app
  * using the city's SODA
  * learning about NSDate & NSCalendar, using it to configure my DateModel
  * furthering my knowledge of adaptive layouts
  * designing the UI and creating my own function that blurs a background image to apply iOS Human Interface Guidelines 
  
###More to come!
