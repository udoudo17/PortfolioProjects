/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------
--Standardize Date Format

  SELECT SaleDateConverted, Convert(date,SaleDate)
  FROM PortfolioProject..NashvilleHousing

  UPDATE NashvilleHousing
  SET SaleDate = Convert(date,SaleDate)

--------------------------------------------------------------------------------------------------------
--Populate Property Address data

  Select *
 from PortfolioProject..NashvilleHousing
 --WHERE PropertyAddress is NULL
 order by ParcelID

   Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 from PortfolioProject.dbo.NashvilleHousing as a
 JOIN PortfolioProject.dbo.NashvilleHousing as b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID] <> b.[UniqueID]
	 where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 from PortfolioProject.dbo.NashvilleHousing as a
 JOIN PortfolioProject.dbo.NashvilleHousing as b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID] <> b.[UniqueID]
	 where a.PropertyAddress is null

----------------------------------------------------------------------------------------------------------
--Breaking out Address into Individual columns; Adress, City, State

Select PropertyAddress
From NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
  Add PropertySplitAddress Nvarchar(255);

   UPDATE NashvilleHousing
  SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

  ALTER TABLE NashvilleHousing
  Add PropertySplitCity Nvarchar(255);

   UPDATE NashvilleHousing
  SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

  SELECT *
  FROM NashvilleHousing

   SELECT OwnerAddress
  FROM NashvilleHousing

  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3),
  PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2),
  PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
  FROM NashvilleHousing

  ALTER TABLE NashvilleHousing
  Add OwnerSplitAddress Nvarchar(255);

   UPDATE NashvilleHousing
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
  
    
  ALTER TABLE NashvilleHousing
  Add OwnerSplitCity Nvarchar(255);
  
   UPDATE NashvilleHousing
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)


   ALTER TABLE NashvilleHousing
  Add OwnerSplitState Nvarchar(255);
  
   UPDATE NashvilleHousing
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


--------------------------------------------------------------------------------------------------------
--CHANGE Y AND N to Yes and No in 'Sold as Vacant' Field

  Select DISTINCT(SoldasVacant), COUNT(SoldasVacant)
  FROM NashvilleHousing
  GROUP BY SoldasVacant
  ORDER BY 2

  SELECT SoldasVacant,
  CASE WHEN SoldasVacant = 'Y'THEN 'YES'
       WHEN SoldasVacant = 'N'THEN 'NO'
	   ELSE SoldasVacant
	   END
  FROM NashvilleHousing

  UPDATE NashvilleHousing
  SET SoldasVacant = CASE WHEN SoldasVacant = 'Y'THEN 'YES'
       WHEN SoldasVacant = 'N'THEN 'NO'
	   ELSE SoldasVacant
	   END

--------------------------------------------------------------------------------------------------------
--REMOVE DUPLICATES
----USING CTE
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
			 ) row_num

FROM NashvilleHousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
where row_num > 1
order by PropertyAddress



--------------------------------------------------------------------------------------------------------
--DELETE UNUSED COLUMNS

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

-------------------------------------------------------------------------------------------------------- 