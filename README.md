# Nobel-TT
Takehome Project

This is a coding project for a previous interview, this project was created in a few hours with the following requirements: 


Nobel Laureates Finder
You are a time traveler. With your fancy time machine, you're able to move through both space and time. Your goal is to witness as many Nobel prize-worthy discoveries as possible. Let's build an app that helps you plan your route.

Inputs
• Coordinates anywhere on the globe as a latitude/longitude pair. • A calendar year between
1900 to 2020, inclusive.
• The dataset of Nobel prize laureates (nobel-prize-laureates.json).

Output
iOS App displaying 20 Nobel laureates that are the closest to the given year and location, in order of ascending cost.
Considerations
• Your algorithm should exhibit a time complexity better than quadratic O(n2).
• You're free to preprocess data the way you want, but solution must be optimized for multiple sequential queries.
• Keep in mind that there is a cost associated with traveling through both space and time. Your time machine is capable of moving 1 year through time expending the same energy as traveling 10km along the surface of Earth. You should consider a jump of (2 years + 0km) as equivalent to (1 year + 10km) and (0 years + 20km).
• As the dataset contains only the year of a discovery (not the day or month), you may consider the cost of travel to an event in the same year as having zero time cost.
• Feel free to be creative with UI, for example providing location input can, but doesn't have to be 2 text fields for latitude and longitude, output can but doesn't have to be a table of names and dates.
