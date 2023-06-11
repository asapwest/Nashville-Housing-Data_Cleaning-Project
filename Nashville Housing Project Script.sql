
/*****************************************
Nashville Housing Data Cleaning Script  
******************************************/

SELECT *
FROM portfolioProject..NashvilleHousing



---------- Standardize the date format ------------

SELECT SaleDate, CONVERT(date,saledate) AS New_SaleDate
FROM portfolioProject..NashvilleHousing

UPDATE portfolioProject..NashvilleHousing
SET saledate = CONVERT(date,saledate)

ALTER TABLE portfolioProject..NashvilleHousing
ADD SalaesDateConverted Date;

UPDATE portfolioProject..NashvilleHousing
SET SalaesDateConverted = CONVERT(date,saledate)

SELECT SalaesDateConverted, CONVERT(date,saledate) AS New_SaleDate
FROM portfolioProject..NashvilleHousing



/****************** Populate Property Addess Date  *********************/
SELECT *
FROM portfolioProject..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.ProPertyAddress, b.ParcelID, b.ProPertyAddress, ISNULL(a.ProPertyAddress, b.ProPertyAddress)
FROM portfolioProject..NashvilleHousing a
JOIN portfolioProject..NashvilleHousing b
	  ON a.ParcelID = b.ParcelID
	  AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.ProPertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.ProPertyAddress, b.ProPertyAddress)
FROM portfolioProject..NashvilleHousing a
JOIN portfolioProject..NashvilleHousing b
	  ON a.ParcelID = b.ParcelID
	  AND a.[UniqueID] <> b.[UniqueID ]




/******************************************
Breaking out Address into Individual Columns (Address, City, State)
*******************************************/

SELECT PropertyAddress
FROM portfolioProject..NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID	 


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS PropertySplitCity
FROM portfolioProject..NashvilleHousing


-------we are creating new columns and add the new value--------

ALTER TABLE portfolioProject..NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE portfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE portfolioProject..NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE portfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *    --the new column added will be on the last end
FROM portfolioProject..NashvilleHousing

SELECT PropertyAddress
FROM portfolioProject..NashvilleHousing


SELECT											  --- This will do same thing as SUBSTRING
	PARSENAME(REPLACE(OwnerAddress,',','.'), 3),  ---ParseName is easier than using SUBSTRING
	PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
	PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM portfolioProject..NashvilleHousing


ALTER TABLE portfolioProject..NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE portfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE portfolioProject..NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE portfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE portfolioProject..NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE portfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT *    ---- confirming the new columns added
FROM portfolioProject..NashvilleHousing



/**** Changing Y and N to Yes and No in "Sold as Vacant" field  ***********/

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM portfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM portfolioProject..NashvilleHousing


UPDATE portfolioProject..NashvilleHousing
SET SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END 


--------------------------------------------------------------
--- Remove Duplicate

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER ( 
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
						UniqueID) as row_num
FROM portfolioProject..NashvilleHousing
)
SELECT *				
FROM RowNumCTE
WHERE row_num > 1 
ORDER BY PropertyAddress



/*********** Deleting Unused Columns ************/

SELECT *
FROM portfolioProject..NashvilleHousing

ALTER TABLE portfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE portfolioProject..NashvilleHousing
DROP COLUMN SaleDate



----- This is the clean data that can be used for analysis henceforth

SELECT *
FROM portfolioProject..NashvilleHousing

