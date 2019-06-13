# Gatra Bali - Balinese News Reader

Balinese news reader app. Now available on Google Play:

[https://play.google.com/store/apps/details?id=com.gatrabali.android](https://play.google.com/store/apps/details?id=com.gatrabali.android)

<img src="https://raw.githubusercontent.com/apps4bali/gatrabali-app/master/appstore/v1.0.0/Banner.png"/>


# How it works
<img src="https://raw.githubusercontent.com/apps4bali/gatrabali-app/master/howitworks.png"/>

1. [Miniflux](https://github.com/apps4bali/miniflux) (an opensource Feed reader written in Go) will periodically check for new articles on a given feeds. Since its quite full featured we're able to add new feed sources, categorize the feed, manage users, etc. Miniflux works independently know nothing about the other parts, store its own data to its own database (PostgreSQL).

1. I don't want the app to talk directly to Miniflux Api but I want Firebase as the app backend instead. So I need a way to transfer data from Miniflux to Firestore. Here I utilise the Google PubSub to trigger a [Cloud Function](https://github.com/apps4bali/gatrabali-functions), whenever an Article is added/updated, Feed is added/updated/deleted, Category is added/updated/deteled Miniflux will publish a message to a Topic and it will trigger the Cloud Function to running. 

1. When the PubSub triggered Function is running, based on the message it received it will make a HTTP request back to the Miniflux REST api to get the Article, Feed or Category object and store them to Firestore.

1. Data that received from Miniflux is stored in Firestore on separate collections, eg. categories, feeds, entries.

1. Because most of the data will be public (user doesn't need to register to use the app except for bookmarks) and to reduce the Firestore reads, some Http Function were used as API frontends to take advantage of caching and some other useful stuff that we can do to our data at this stage. And the last but not least, I put Firebase hosting at very front to take advantage of rewrites (to have a beautiful API url) and also CDN caching.

1. For the bookmarks, app read and write directly to Firestore, users are only allowed to read and write to their own bookmarks collection by using Firestore rules.

Thats it! you may think its a bit overkill for such a simple News Reader app, but for me its about scalability and stability of the system. If for example the server that host Miniflux somehow lost all of its data in database, the app will continue to works without a problem.
