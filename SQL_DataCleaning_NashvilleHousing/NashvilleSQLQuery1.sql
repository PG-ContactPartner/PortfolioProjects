/*
Cleaning Data
*/

SELECT *
FROM Nashville.dbo.Housing

-- 1. Standardize Date Format

-- Convert "SaleDate" column to a standard date format
	--1.1 Create Column
ALTER TABLE Nashville.dbo.Housing
ADD SaleDateConverted Date;

	--1.2 Add standard date format to new column "SaleDateConverted"
UPDATE Nashville.dbo.Housing
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- 2. Populate "PropertyAddress" fields with NULLs by extrating the correspondent address from "Property Address" records with the same ParcelID number.

SELECT *
FROM Nashville.dbo.Housing
WHERE PropertyAddress

-- 2.1 Filter data

SELECT a.ParcelID, a.PropertyAddress,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville.dbo.Housing a
JOIN Nashville.dbo.Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--2.2 Add addresses to "PropertyAddress" NULLs, extracted from "PropertyAddress" records with the same ParcelID number

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville.dbo.Housing a
JOIN Nashville.dbo.Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- 3. Breaking out address into individual columns (address, city, state)
	-- 3.1 Column "PropertyAddress"

SELECT PropertyAddress
FROM Nashville.dbo.Housing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM Nashville.dbo.Housing

	-- Address
ALTER TABLE Nashville.dbo.Housing
ADD PropertySplitAddress Nvarchar(255)

UPDATE Nashville.dbo.Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

	-- City
ALTER TABLE Nashville.dbo.Housing
ADD PropertySplitCity Nvarchar(255)

UPDATE Nashville.dbo.Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

	-- 3.2 Column "OwnerAddress"

SELECT OwnerAddress
FROM Nashville.dbo.Housing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM Nashville.dbo.Housing

	-- Address
ALTER TABLE Nashville.dbo.Housing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE Nashville.dbo.Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

	-- City
ALTER TABLE Nashville.dbo.Housing
ADD OwnerSplitCity Nvarchar(255)

UPDATE Nashville.dbo.Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

	-- State
ALTER TABLE Nashville.dbo.Housing
ADD OwnerSplitState Nvarchar(255)

UPDATE Nashville.dbo.Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

--4. Change Y and N to Yes and NO in column "SoldAsVacant" fields

 SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Nashville.dbo.Housing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Nashville.dbo.Housing

UPDATE Nashville.dbo.Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Nashville.dbo.Housing
	

--5. Remove Duplicates

	-- Shortlist duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) RowNum
				   					 				
FROM Nashville.dbo.Housing
)

SELECT *
FROM RowNumCTE
WHERE RowNum > 1
ORDER BY PropertyAddress

	-- Delete duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) RowNum
				   					 				
FROM Nashville.dbo.Housing
)

DELETE  -- *Delete
FROM RowNumCTE
WHERE RowNum > 1


-- 6. Delete columns not required

ALTER TABLE Nashville.dbo.Housing
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

	-- Checking
SELECT *
FROM Nashville.dbo.Housing




