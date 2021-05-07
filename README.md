# hubble

## Demo Live Links: 
youtu.be/-GaKWMUCaaM?t=4511
goo.gle/GoogleCloudDemoWeek
https://hubbleapp.dev

## Project introduction
With virtual school (yay Zoom!) and no in-person social events (rip Beta Apple Pie), it was hard to meet people with similar interests in your classes so you could be project partners/study buddies/friends. hubble takes care of all of this with a custom matching algorithm that lets you know how similar you are to other students based on similar courses, interests and who they are!

## Issue/Inspiration
Martin 3 days before DubHacks @ 3 am was lying in bed overthinking about life as usual. His new friend in his communications class had been saying how she was glad to have messaged him through FB as they turned out to be amazingly compatible study buddies/project partners (based on the many similar courses they were taking at the time and interests in talking about wack af relationships and how the prof gave way too much work for the class).

However, she lamented the fact that she would not have had a great project partner if she hadn't taken the leap to message him on FB. Martin thought to himself, other students must be struggling to find project partners/friends in class that had similar interests as them. Could it be possible to build an app that facilitated this process? This was the very beginning for hubble, where Linda suggested using Google's NLP to help do so during the hackathon.

## What it does
hubble, in essence, is a social networking app. Users can freely choose who they wish to connect with. Our algorithm returns an emoji based on how we think you are compatible with the other user based on your interests, hobbies, clubs and courses.

😃 - Good Compatibility 😆 - Great Compatibility 🤩 - Amazing Compatibility

Once you connect with someone, you can chat with them using the built-in chat feature, where you can send images about the lab you missed or talk about anything school. (or maybe not).

How did your project evolve with the support of the COVID-19 hackathon fund by Google Cloud?
Jerry was an amazing mentor who gave us great insight on how to organize our data on Firebase, and how we could optimize queries and save on them by caching our data locally. He's also a pretty cool guy so you can say his coolness made the project a lot more cool.

Due to the ability to increase our team size, we were also able to take on a UI designer and another Back-end developer at the beginning of this project (shoutout Sarah Dang, Dang! She's kinda cool and Steven Le, Le best refactorer) to help us with ideating our new design with Flutter and refactoring our algorithm.

We were also able to use the funds by spamming the database and cloud functions with queries/invocations. Neat to see how cheap it is to operate Firebase and the NLP though.

## How you built it
hubble was built using Flutter as it's front-end to create an intuitive and user-friendly interface for both iOS and Android users. (no more only iOS!) Our custom matching algorithm was implemented in JavaScript via Node.js hosted on Google Cloud Functions, which calls open Google's Natural Language Processing (NLP) to parse and compare user data.

The algorithm then returns scores for each user on the database based on a weighted heuristic from your own data, which is then assigned an emoji for you to see. The database uses Firebase's Cloud Firestore and Cloud Storage to handle data about users!

## Challenges you ran into
The team became only Martin & Linda to work on our own time to rework the entire front-end from scratch. (We don't forget the hard work that Anshay Saboo, Steven Le and Sarah Dang put to set us up for where we are now though!)

Kinda very obscure errors that Stack Overflow couldn't solve. Turns out randomly changing things somehow can fix it? (Martin has no idea to this day how he fixed the random auth bug that prevented us from working on the project 3 days before submission)

Really random bugs that would pop up with our cloud function occasionally breaking depending on the frequency of invocations and any changes to the database.

The FlutterFire documentation in the very beginning was super confusing, but has improved a lot in the couple months since we started!

DNS servers are super weird when it comes to registering a new domain.

## Accomplishments you are proud of
Worked very slowly in the first 4 months then finished the entire front-end in 5 days flat. (Is this called exponentially increasing productivity? (EIP) or just procrastination…)

Breaking the authentication system and iOS emulator 3 days before the demo submission deadline.

Both Martin and Linda have zero experience with any of making an NLP matching algorithm, building a mobile application, working with noSQL databases. So building an app that actually works, looks amazing and intuitive and is ready to deploy is something we are super proud of!

## What you learned
Imagine paying 12k tuition for 2 years @ ubc just to learn the same amount (size-wise) of content in the last four months. haha.

No, really, we learned so, so, so much. We learned everything from using Mocha to do JavaScript unit testing on our matching algorithm, to learning how Firebase integrates with mobile applications and the optimization of queries/invocations to Firebase. We also learned how to build a mobile application basically from scratch with zero prior knowledge and only a simple Figma file to follow for UI/UX. And that's just the condensed version of it.

The mentorship opportunity also gave us high-level insight on optimizations/improvements we could make to our app. From caching, learning potential concepts of using ML to assist in our weighted heuristics, (similar to TikTok's FYP) and the introduction of using overnight operations that we can use in the future for scalability; we were all super new to these concepts. We are super grateful and excited to be given this opportunity by Google Cloud to be able to learn what it takes to build an entire (basically a startup) application from the ground up.

## What’s next for your project
hubble is going to be in an invite-only closed beta for the students @ the University of British Columbia, where later in the summer we look to open it up to more students across North America. You can register @ https://hubbleapp.dev We also like to introduce messaging boards for each of the classes you're in so you can rant all about the tight deadlines your professors designated or the abyssal 46% midterm average in Calculus 2. Or you can also peek into other classes to see how good (or bad) they are doing! hubble looks to deploy to the public in late August before school starts!
