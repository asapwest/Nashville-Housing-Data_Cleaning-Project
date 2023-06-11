# Nashville-Housing-Data_Cleaning-Project

This SQL script is designed to clean and prepare the Nashville Housing dataset for analysis. 

### Script Overview
The script performs the following data cleaning steps:

Standardizes the date format by converting the "SaleDate" column to the date data type.
Populates missing property addresses by matching records with the same ParcelID and different UniqueID values.
Breaks down the "PropertyAddress" column into separate columns for Address and City.
Adds new columns for split address components (Address, City) and populates them accordingly.
Converts "SoldAsVacant" values from 'Y' and 'N' to 'Yes' and 'No' respectively.
Removes duplicate rows from the dataset based on specific columns.
Deletes unused columns (OwnerAddress, TaxDistrict, SaleDate) to streamline the dataset.
The script concludes with a query displaying the cleaned dataset, which can be used for further analysis.

### Notes
It's important to review the cleaned dataset obtained from the final query to ensure the data is properly cleaned and ready for analysis.
Make sure you have appropriate access rights and permissions to execute the queries on the database.
Adjust the database and table names if they differ in your environment.
Please let me know if you need any further assistance or have any questions related to the script or the Nashville Housing dataset.
