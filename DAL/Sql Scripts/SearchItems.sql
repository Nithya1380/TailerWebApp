ALTER PROCEDURE SearchItems
(
  @CompanyID INT,
  @BranchID INT,
  @UserID INT=NULL,
  @SearchText VARCHAR(500)=''
)
AS

BEGIN
   SELECT ItemMaster.ItemmasterID,ItemMaster.ItemDescription,ItemMaster.ItemCode,ItemMaster.ItemPrice,ItemMaster.ItemGroup
     FROM ItemMaster WITH(nolock)
	   WHERE ItemMaster.CompanyID=@CompanyID
	     --AND CustomerMaster.BranchID=@BranchID
		 AND (ItemMaster.ItemCode LIKE '%'+@SearchText+'%'
		      OR ItemMaster.ItemDescription LIKE '%'+@SearchText+'%'
			  OR ItemMaster.ItemAlias LIKE '%'+@SearchText+'%'
		  )
		  AND ISNULL(ItemMaster.isDeleted,0)=0
		  FOR JSON PATH

	RETURN 1
END