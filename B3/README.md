# Brazilian Stock Exchange - B3

*This is the fourth version of the code. Old versions can be found in the "Old versions" folder.

This code automatically downloads Reference Rates (DI x Pré) from B3 website. It download rates of 252 and 360 days, but by default, it uses only 252 days.  You can change that inside the code.

The code was created to download the last data avaiable. With this in mind, it's not possible to choose data from specific dates.

The code uses the following packages:

- `rvest`;
- `stringr`;
- `bizdays`;
- `lubridate`.

It creates a data frame with the following days:

- 30 days;
- 60 days;
- 90 days;
- 120 days;
- 180 days;
- 360 days;
- 720 days;
- 1080 days.



