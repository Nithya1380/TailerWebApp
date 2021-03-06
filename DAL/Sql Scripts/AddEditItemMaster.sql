
/****** Object:  StoredProcedure [dbo].[AddEditItemMaster]    Script Date: 01-12-2018 16:02:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AddEditItemMaster]
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
	  

   IF EXISTS(SELECT 1 FROM OPENJSON(@itemMasterObj) 
               WITH(
					 ItemCode VARCHAR(100) '$.ItemCode' ,  
					 ItemDescription   VARCHAR(200) '$.ItemDescription',
					 ItemGroup VARCHAR(100) '$.ItemGroup',
					 ItemPrice VARCHAR(15) '$.ItemPrice'
				   )
				 WHERE ISNULL(ItemCode,'')='' OR ISNULL(ItemDescription,'')='' OR ISNULL(ItemGroup,'')='' OR ISNULL(ItemPrice,'')='')
	 RETURN -2

  IF EXISTS(SELECT 1 FROM ItemMaster WITH(nolock)
                 CROSS APPLY(SELECT ItemCode FROM OPENJSON(@itemMasterObj) 
								 WITH(
									  ItemCode VARCHAR(100) '$.ItemCode'
									)
				            ) AS NewItem
		       WHERE CompanyID=@companyID
			     AND ItemMaster.ItemCode=NewItem.ItemCode
				 AND ItemmasterID<>@ItemMasterID)
	   RETURN -3
	
	IF NOT EXISTS(SELECT 1 FROM ItemMaster WITH(nolock) WHERE CompanyID=@companyID AND ItemmasterID=@ItemMasterID)
	BEGIN
		INSERT INTO ItemMaster(CompanyID,ItemCode,ItemDescription,ItemGroup,ItemAlias,ItemPrice,CreatedOn,CreatedBy, TotalGST, SGSTPer, SGST, CGSTPer, CGST, BillAmt)
		SELECT @companyID,ItemCode,ItemDescription,ItemGroup,ItemAlias,ItemPrice,GETDATE(),@UserID, TotalGST, SGSTPer, SGST, CGSTPer, CGST, BillAmt
		 FROM OPENJSON(@itemMasterObj) 
			WITH(
				ItemCode VARCHAR(50) '$.ItemCode' ,  
				ItemDescription   VARCHAR(200) '$.ItemDescription',
				ItemGroup   VARCHAR(50) '$.ItemGroup',
				ItemAlias VARCHAR(100) '$.ItemAlias',
				ItemPrice VARCHAR(15) '$.ItemPrice',
				TotalGST FLOAT '$.TotalGST', 
				SGSTPer FLOAT '$.SGSTPer',
				SGST FLOAT '$.SGST', 
				CGSTPer FLOAT '$.CGSTPer', 
				CGST FLOAT '$.CGST', 
				BillAmt FLOAT '$.BillAmt'
			)

	   SET @ItemMasterID=SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
	   DECLARE @ItemRateID INT

	  ;WITH Item_CTE AS
	  (
	    SELECT ItemCode,ItemDescription,ItemGroup,ItemAlias,ItemPrice,TotalGST, SGSTPer, SGST, CGSTPer, CGST, BillAmt
		 FROM OPENJSON(@itemMasterObj) 
			WITH(
				ItemCode VARCHAR(50) '$.ItemCode' ,  
				ItemDescription   VARCHAR(200) '$.ItemDescription',
				ItemGroup   VARCHAR(50) '$.ItemGroup',
				ItemAlias VARCHAR(100) '$.ItemAlias',
				ItemPrice VARCHAR(15) '$.ItemPrice',
				TotalGST FLOAT '$.TotalGST', 
				SGSTPer FLOAT '$.SGSTPer',
				SGST FLOAT '$.SGST', 
				CGSTPer FLOAT '$.CGSTPer', 
				CGST FLOAT '$.CGST', 
				BillAmt FLOAT '$.BillAmt'
			)
	  )

	  UPDATE ItemMaster SET ItemCode=Item_CTE.ItemCode,
	                        ItemDescription=Item_CTE.ItemDescription,
							ItemGroup=Item_CTE.ItemGroup,
							ItemAlias=Item_CTE.ItemAlias,
							ItemPrice=Item_CTE.ItemPrice,
							TotalGST = Item_CTE.TotalGST,
							SGSTPer = Item_CTE.SGSTPer,
							SGST = Item_CTE.SGST,
							CGSTPer = Item_CTE.CGSTPer,
							CGST = Item_CTE.CGST,
							BillAmt = Item_CTE.BillAmt
		FROM Item_CTE
		  WHERE CompanyID=@companyID 
		    AND ItemmasterID=@ItemMasterID

	  SELECT @ItemRateID=ItemRateID
	    FROM ItemRates WITH(nolock)
		  WHERE ItemRates.CompanyID=@companyID
		    AND ItemMasterID=@ItemMasterID
			AND StartDate IS NULL

		UPDATE ItemRates 
			SET ItemPrice=ItemMaster.ItemPrice,
				TotalGST = ItemMaster.TotalGST,
				SGSTPer = ItemMaster.SGSTPer,
				SGST = ItemMaster.SGST,
				CGSTPer = ItemMaster.CGSTPer,
				CGST = ItemMaster.CGST,
				BillAmt = ItemMaster.BillAmt
		  FROM ItemMaster WITH(nolock)
		    WHERE ItemRates.ItemMasterID=ItemMaster.ItemmasterID
			  AND ItemRates.ItemRateID=@ItemRateID
	END
	
	RETURN 1
END
