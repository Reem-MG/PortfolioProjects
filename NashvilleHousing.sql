Select* 
From Portfolioproject.dbo.NashvillHousing

--Standerize Date Fromat

Select SaleDateConverted, CONVERT(date, saledate)
From Portfolioproject.dbo.NashvillHousing

Update NashvillHousing
Set saledate = Convert(date, SaleDate)

ALter table NashvillHousing
add saleDateConverted date;

Update NashvillHousing
Set saleDateConverted = Convert(date, SaleDate)

---Populate Property Address Data

Select *
From Portfolioproject.dbo.NashvillHousing
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
From Portfolioproject.dbo.NashvillHousing a
Join Portfolioproject.dbo.NashvillHousing b
on a. ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHere a.PropertyAddress is null

Update a
set Propertyaddress = ISNULL(a.propertyAddress,b.PropertyAddress)
from Portfolioproject.dbo.NashvillHousing a
join Portfolioproject.dbo.NashvillHousing b
on a. ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHere a.PropertyAddress is null

--Breaking out Address into Individual columns (Address, City, State)

select PropertyAddress
From Portfolioproject.dbo.NashvillHousing

select
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as address
, substring(PropertyAddress, charindex(',', PropertyAddress) +1 ,LEN(PropertyAddress)) as address

From Portfolioproject.dbo.NashvillHousing


ALter table NashvillHousing
add PropertySplitAddress Nvarchar(225);


Update NashvillHousing
Set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)  


ALter table NashvillHousing
add PropertySplitCity Nvarchar(225);

Update NashvillHousing
Set PropertySplitCIty = substring(Propertyaddress, charindex(',', propertyaddress) +1 ,LEN(PropertyAddress))

Select*
From Portfolioproject.dbo.NashvillHousing




Select OwnerAddress
From Portfolioproject.dbo.NashvillHousing

Select
parsename(Replace(Owneraddress, ',', '.') , 3)

,parsename(Replace(Owneraddress, ',', '.') , 2)

,parsename(Replace(Owneraddress, ',', '.') , 1)
From Portfolioproject.dbo.NashvillHousing

ALter table NashvillHousing
add OwnerSplitAddress Nvarchar(225);


Update NashvillHousing
Set OwnerSplitAddress = parsename(Replace(Owneraddress, ',', '.') , 3)


ALter table NashvillHousing
add OwnerSplitCity Nvarchar(225);


Update NashvillHousing
Set OwnerSplitCity = parsename(Replace(Owneraddress, ',', '.') , 2)

ALter table NashvillHousing
add OwnerSplitState Nvarchar(225);


Update NashvillHousing
Set OwnerSplitState = parsename(Replace(Owneraddress, ',', '.') , 1)

--Change Y and N to Yes and No in SoldAsVacant Field

Select Distinct(SoldAsVacant), count(soldasvacant)
From Portfolioproject.dbo.NashvillHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant = 'Y' THEN 'Yes'
       WHen SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
From Portfolioproject.dbo.NashvillHousing

ALter table NashvillHousing
add SOldAsVacant Nvarchar(225);

Update NashvillHousing
Set SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
       WHen SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END


--Remove Duplicates

with RowNumCTE as(
Select*,
Row_number() over (
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 Legalreference
			 Order by 
			   UniqueID
			   ) Row_num

From Portfolioproject.dbo.NashvillHousing
--order by ParcelID
)
Select*
From RowNumCTE
where Row_num > 1
--Order by PropertyAddress


--Delete Unused Columns

Select*
From Portfolioproject.dbo.NashvillHousing

Alter Table Portfolioproject.dbo.NashvillHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table Portfolioproject.dbo.NashvillHousing
Drop Column SaleDate