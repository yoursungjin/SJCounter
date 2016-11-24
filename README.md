# SJCounter

## Background
I was asked to write a demo iOS app in Objective-C that displays a table of counters<br> 
, which should meet the main requirements as follows. <br>
- A user can create, delete a counter. <br>
- A user can increment or decrement a counter value. <br>
- Ordering, naming, and counter values should be persisted between app launches.

## Requirements in detail.
The app should feature the same functionality as the app seen in the demo video.<br>
Click the image below to play the demo video.<br>

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/sLMPuT0Dqa4/0.jpg)](https://www.youtube.com/watch?v=sLMPuT0Dqa4)

The app should:<br>
- Allow a user to CREATE a new counter entry, inserted at the TOP of the list.<br>
- Allow a user to NAME a counter entry upon creation.<br>
- Allow a user to INCREMENT or DECREMENT a counter.<br>
- Allow a user to DELETE a counter entry.<br>
- Allow a user to REORDER the position of a counter.<br>
- IMPORTANT: persist counter states (name, value, and position)
   so subsequent app-launches start up with the same state as when the user left it, including when the app is forcefully terminated. Incrementing/decrementing a counter after re-launch should alter the value from what it was last.
  
## Solution
The solution features:
- ARC
- NSCoding for serialization.
- KVO for notifications from the changes of model.
- Auto layout for the support of iPhone/iPad, and portrait/landscape.
- Customized tableViewCell.
