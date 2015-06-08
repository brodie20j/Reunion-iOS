Carleton Reunion


=======
Made for Carleton Reunion 2015

Client: Erin Updike

Team Members: Grant Terrien, Jonathan Brodie, Alex Mathson

Project Description:
	This app is intended to be used by attendees of the annual Carleton Reunion.
Currently, this app fetches and displays the Reunion 2015 schedule, displays a map of campus with options to center the map over campus buildings, and has views for the Carleton Directory, Reunion photo upload, Reunion A to Z page, and a Twitter view that shows all tweets containing #carlreunion. This app also parses the RSS feed for Reunion Updates, but we didn't get to spend as much time on writing this code as we would have liked. The app is able to successfully retrieve and display the titles of any updates to the RSS feed, but it isn't yet able to properly display updates with no content other than the title. 

Getting Fabric:
	This project requires the Fabric to build and run. To get Fabric, create an
account at https://get.fabric.io and install Fabric. Once fabric is installed, sign in and add the Twitter kit to the folder containing the Xcode project for this app.

Future Development:
	Most of the key features that this app needs for development are already in 
place. Some next steps in the development of this app include taking more time to imrpove the code that parses the RSS feed, using the Social Framework built into iOS instead of Fabric and adding the ability to hide banned usernames from the Twitter feed, using push notifications to display important updates rather than an RSS feed and popup notifications, and replacing the web views in this project with views that parse the plain HTML of the related page to improve responsiveness and to create a consistent style across all of the screens in this app.