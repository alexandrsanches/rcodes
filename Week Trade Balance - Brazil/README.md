# Week Trade Balance from Ministry of Industry, Foreign Trade and Services

*This is the sixth version of the code. Old versions can be found in the "Old versions" folder.

This code was made to download information automatically from MIFTS. It downloads week information about Brazilian trade balance, bringing export and import data. 

The code needs the Excel spreadsheet "Week Trade Balance" to check the last available date and downloads the next. It exports the same spreadsheet containing the historical serie since January 2000.

The code uses the following packages:

- `lubridate`
- `bizdays`
- `xts`
- `openxlsx`



