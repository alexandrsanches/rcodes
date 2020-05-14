# Organization for Economic Co-operation and Development Data

*This is the third version of the code. Old versions can be found in the "Old versions" folder.

This code was written to automatically download data from OECD website. It downloads Gross Domestic Product, Inflation and Unemployment Rate data of every available country. A filter was used to select only dates after 2010, but it can be changed within the code.

There are four codes: GDP, Inflation, Unemployment Rate and RunCodes. The latter has the necessary packages for everything to work well. The code generates a separate Excel spreadsheet for each available data, they're saved into the folder "Downloaded Files".

The GDP spreadsheet is separated into 4 tabs: 

- GDP TT1 - gross domestic product compared to the previous quarter;

- GDP TT4 - gross domestic product compared to the same quarter of the previous year;

- Rank TT1 - a ranking with the latest available data in ascending order with GDP compared to the previous quarter;

- Rank TT4 - a ranking with the latest available data in ascending order with GDP compared to the same quarter of the previous year.

The code uses the following packages:

- `readr`
- `openxlsx`
- `lubridate`
- `stringr`
- `reshape`

Countries available:

- Argentina
- Australia
- Austria
- Belgium
- Brazil
- Canada
- Chile
- Czech Republic
- Germany
- Denmark
- Euro Zone
- Spain
- Estonia
- European Union
- Finland
- France
- G7
- United Kingdom
- Greece
- Hungary
- Ireland
- Iceland
- Israel
- Italy
- Japan
- South Korea
- Lithuania
- Luxembourg
- Salvador
- Mexico
- Netherlands
- Norway
- OECD
- Poland
- Portugal
- Slovakia
- Slovenia
- Sweden
- Turkey
- United States


