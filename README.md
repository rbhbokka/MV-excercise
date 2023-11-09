# MV-excercise
SwiftUI excercize implementing MV pattern.
I wanted to avoid over-engineering here and I believe most of SwiftUI projects don't need fancy architectures at all, framework itself provides better solutions. 
Model-View is enough.

App is utilizing swift-collections spm package because… because why not? 
OrderedSet is a great way to check uniqueness while keeping collection in order.

I think most interesting part of this excercise was parsing of dynamically keyed JSON and I wanted to avoid 150 lines of equal model fields being present.
You can take a look at MealDetailsResponse, it is simple and does its job perfectly. Never found a dessert with more than 20 ingredients, but in that case it would be a Set<String: String> probably.

Errors are being thrown to UI layer. Nothing to actually filter or handle here: 404s are not expected as details are requested by existing IDs, filter is returning array even if it is empty, other types of errors are not documented and I have no fallbacks for 500 and above.

Compiled and validated with Xcode 15.0.1 + iOS 17.0
It work on iPhone, iPad, Mac without any UX issues.
Colors and fonts are system native, so app look ok in dark and light mode.
