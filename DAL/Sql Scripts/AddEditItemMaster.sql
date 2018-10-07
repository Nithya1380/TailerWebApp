SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddEditItemMaster]
(
   @companyID INT,
   @UserID INT,
   @UserBranchID INT,
   @ItemMasterID INT,
   @itemMasterObj VARCHAR(2000)
)

AS

BEGIN
   IF NOT EXISTS(SELECT 1 FROM CompanyMaster WITH(nolock) WHERE CompanyID=@companyID)
	RETURN -1
	  

   IF EXISTS(SELECT 1 FROM OPENJSON(@ItemMasterID) 
               WITH(
					 ItemCode VARCHAR(100) '$.ItemCode' ,  
					 ItemDescription   VARCHAR(200) '$.ItemDescription',
					 ItemGroup VARCHAR(100) '$.ItemGroup',
					 ItemPrice VARCHAR(15) '$.ItemPrice'
				   )
				 WHERE ISNULL(ItemCode,'')='' OR ISNULL(ItemDescription,'')='' OR ISNULL(ItemGroup,'')='' OR ISNULL(ItemPrice,'')='')
	 RETURN -2

  IF EXISTS(SELECT 1 FROM ItemMaster WITH(nolock)
                 CROSS APPLY(SELECT ItemCode FROM OPENJSON(@ItemMasterID) 
								 WITH(
									  ItemCode VARCHAR(100) '$.ItemCode'
									)
				            ) AS NewItem
		       WHERE CompanyID=@companyID
			     AND ItemMaster.ItemCode=NewItem.ItemCode
				 AND ItemmasterID<>@ItemMasterID)
	   RETURN -3
	
	IF EXISTS(SELECT 1 FROM ItemMaster WITH(nolock) WHERE CompanyID=@companyID AND ItemmasterID=@ItemMasterID)
	BEGIN
		INSERT INTO ItemMaster(CompanyID,ItemCode,ItemDescription,ItemGroup,ItemAlias,ItemPrice,CreatedOn,CreatedBy)
		SELECT @companyID,ItemCode,ItemDescription,ItemGroup,ItemAlias,ItemPrice,GETDATE(),@UserID 
		 FROM OPENJSON(@ItemMasterID) 
			WITH(
				ItemCode VARCHAR(50) '$.ItemCode' ,  
				ItemDescription   VARCHAR(200) '$.ItemDescription',
				ItemGroup   VARCHAR(50) '$.ItemGroup',
				ItemAlias VARCHAR(100) '$.ItemAlias',
				ItemPrice VARCHAR(15) '$.ItemPrice'
			)

	   SET @ItemMasterID=SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
	  ;WITH Item_CTE AS
	  (
	    SELECT ItemCode,ItemDescription,ItemGroup,ItemAlias,ItemPrice
		 FROM OPENJSON(@ItemMasterID) 
			WITH(
				ItemCode VARCHAR(50) '$.ItemCode' ,  
				ItemDescription   VARCHAR(200) '$.ItemDescription',
				ItemGroup   VARCHAR(50) '$.ItemGroup',
				ItemAlias VARCHAR(100) '$.ItemAlias',
				ItemPrice VARCHAR(15) '$.ItemPrice'
			)
	  )

	  UPDATE ItemMaster SET ItemCode=Item_CTE.ItemCode,
	                        ItemDescription=Item_CTE.ItemDescription,
							ItemGroup=Item_CTE.ItemGroup,
							ItemAlias=Item_CTE.ItemAlias,
							ItemPrice=Item_CTE.ItemPrice
		FROM Item_CTE
		  WHERE CompanyID=@companyID 
		    AND ItemmasterID=@ItemMasterID
	END
	
	RETURN 1
END