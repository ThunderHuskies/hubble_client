# Hubble

University networking made fun, easy, and straightforward. Connect with professors and students using a familiar at-a-glance interface and smart matching algorithms.

## Purpose

With virtual school and no in-person events due to COVID-19, it has become extremely hard to make friends, especially if you want to make study buddies in class or meet potential lab partners.

So, we decided to create Hubble, where users can choose to connect with other users and be friends :) We have our own custom algorithm that lets users know whether the person they are swiping on would be a good match based on their interests or courses they are taking!

## How We Built It
Hubble was built with Flutter to create an intuitive and user-friendly iOS and Android application. The data retrieved from users is stored in Cloud Firestore. Our custom matching algorithm was implemented in Node.js. The matching algorithm calls upon Google's Natural Language Processing (NLP) API to parse the user inputted data. This data is then compared against all other matches, updating live whenever the application is launched.
