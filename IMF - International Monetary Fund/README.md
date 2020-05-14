# International Monetary Fund - World Economic Outlook

*This is the second version of the code. Old versions can be found in the "Old versions" folder.

World Economic Outlook is a survey produced by International Monetary Fund (IMF) and usually published twice a year, on April and October. It presents IMF staff economists' analyses of global economic developments during the near and medium term.  

It give an overview as well as more detailed analysis of the world economy; considering issues affecting industrial countries, developing countries, and economies in transition to market; and address topics of pressing current interest.

This code automatically downloads IMF World Economic Outlook. A filter was used to select some countries, but it can be changed within the code. It was created to update an Excel spreadsheet, and you need it to check the last available date to download the next one.

The code uses the following packages:

- `openxlsx`
- `stringr`
- `dplyr`
- `lubridate`

The code downloads the following data:

1. Gross domestic product, constant prices;
2. Inflation, end of period consumer prices (only for country groups);
3. Inflation, average consumer prices (only for countries);
4. Trade volume of goods and services (only for world);
5. Unemployment rate (not available for all countries and groups).

And it download data from the following countries by default:

- Countries:
  - China;

  - Japan;

  - United States.

- Groups:
  - Advanced economies;
  - Euro area;
  - European Union;
  - Emerging market and developing economies;
  - Latin America and the Caribbean.

