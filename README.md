# ISO8601DurationParser
Swift 5 `ISO8601DateFormatter` extension that parses ISO 8601 duration strings and returns the corresponding date components or adds components to a date.

### ISO 8601 Durations Overview
Durations define the amount of intervening time in a time interval and are represented by the format P[n]Y[n]M[n]DT[n]H[n]M[n]S or P[n]W as shown to the right. In these representations, the [n] is replaced by the value for each of the date and time elements that follow the [n]. Leading zeros are not required, but the maximum number of digits for each element should be agreed to by the communicating parties. The capital letters P, Y, M, W, D, T, H, M, and S are designators for each of the date and time elements and are not replaced.

P is the duration designator (for period) placed at the start of the duration representation.
Y is the year designator that follows the value for the number of years.
M is the month designator that follows the value for the number of months.
W is the week designator that follows the value for the number of weeks.
D is the day designator that follows the value for the number of days.
T is the time designator that precedes the time components of the representation.
H is the hour designator that follows the value for the number of hours.
M is the minute designator that follows the value for the number of minutes.
S is the second designator that follows the value for the number of seconds.
For example, "P3Y6M4DT12H30M5S" represents a duration of "three years, six months, four days, twelve hours, thirty minutes, and five seconds".

From https://en.wikipedia.org/wiki/ISO_8601#Durations.

### Usage
```
let dateComponents = ISO8601DateFormatter.durationComponents(from: "P1Y2M3DT6H15M30S")
//  Results in an optional date component:
//  - year: 1, month: 2. day: 3, hour: 6, minute: 15, second: 30, isLeapMonth: false 

let dateWithDuration = ISO8601DateFormatter.date(byAdding: "P1Y2M3DT6H15M30S", to: Date())
//  Results in an optional date that is 1 year, 2 months, 3 days, 6 hours, 15 minutes, and 30 seconds from now.
```

### License
This extension is licensed under the MIT License.
