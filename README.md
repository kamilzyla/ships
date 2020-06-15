### Data anomalies
Ideally, each ship ID should correspond to exactly one ship. Unfortunately, the data set has some
anomalies: some IDs are listed with different ship names or types. In some cases this clearly
seems to be a typo (e.g. "SEASTAR ENDURANCE" and "ZBASTAR ENDURANCE" with ID 406999) but in other
cases it is not so obvious.

To avoid doing manual data cleanup I assume that a (type, name, id) triple uniquely identifies each
ship. In the cases where (type, name) pair has multiple corresponding IDs, I append the ship ID to
its name to uniquely identify it in the UI.


### Possible improvements
User experience:
* Avoid briefly resetting to world map when changing vessel type.
* Use different marker colors for start and end points.
* Display the map on the whole page with an overlay panel for vessel choice
  (like [here](https://shiny.rstudio.com/gallery/superzip-example.html)).

Code quality:
* Avoid "objects are masked" warnings (possibly using `loadNamespace`).
* Add `testthat` unit tests for `readShips.R`.
* Avoid the overhead of remembering and filtering a data frame on user interaction
  (stateless session, `type -> name -> observation` hash map).

Recruitment points:
* Deploy to Google Cloud or AWS to show that I can use them ;)
