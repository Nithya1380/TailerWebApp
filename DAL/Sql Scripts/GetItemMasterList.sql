CREATE PROCEDURE GetItemMasterList
(
	@companyID INT,
	@UserID INT,
	@ItemMasterID INT=0
)
AS

BEGIN
	IF(ISNULL(@companyID,0)=0)
		RETURN -1

   IF(ISNULL(@ItemMasterID,0)=0)
   BEGIN
		SELECT ItemmasterID,
			   ItemCode,
			   ItemDescription,
			   ItemGroup,
			   ItemAlias,
			   ItemPrice
			 FROM ItemMaster WITH(NOLOCK)
				WHERE ItemMaster.CompanyID=@companyID
					FOR JSON PATH
	END
	ELSE
	BEGIN
		SELECT ItemmasterID,
			   ItemCode,
			   ItemDescription,
			   ItemGroup,
			   ItemAlias,
			   ItemPrice
			 FROM ItemMaster WITH(NOLOCK)
				WHERE ItemMaster.CompanyID=@companyID
				  AND ItemMaster.ItemmasterID=@ItemMasterID
					FOR JSON PATH
	END

	RETURN 1
END
