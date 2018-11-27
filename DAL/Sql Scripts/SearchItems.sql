GO
/****** Object:  StoredProcedure [dbo].[SearchItems]    Script Date: 27-Nov-2018 22:46:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SearchItems]
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
