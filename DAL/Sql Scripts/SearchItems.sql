
/****** Object:  StoredProcedure [dbo].[SearchItems]    Script Date: 01-12-2018 16:13:06 ******/
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
   SELECT ItemMaster.ItemmasterID,ItemMaster.ItemDescription,ItemMaster.ItemCode,
          IIF(ISNULL(ItemRates.ItemPrice,0)<>0, ItemRates.ItemPrice, ItemMaster.ItemPrice) AS ItemPrice,
		  ItemMaster.ItemGroup,
		  IIF(ISNULL(ItemRates.ItemPrice,0)<>0, ItemRates.TotalGST, ItemMaster.TotalGST) AS TotalGST,
		  IIF(ISNULL(ItemRates.ItemPrice,0)<>0, ItemRates.SGSTPer, ItemMaster.SGSTPer) AS SGSTPer,
		  IIF(ISNULL(ItemRates.ItemPrice,0)<>0, ItemRates.SGST, ItemMaster.SGST) AS SGST,
		  IIF(ISNULL(ItemRates.ItemPrice,0)<>0, ItemRates.CGSTPer, ItemMaster.CGSTPer) AS CGSTPer,
		  IIF(ISNULL(ItemRates.ItemPrice,0)<>0, ItemRates.CGST, ItemMaster.CGST) AS CGST,
		  IIF(ISNULL(ItemRates.ItemPrice,0)<>0, ItemRates.BillAmt, ItemMaster.BillAmt) AS BillAmt
     FROM ItemMaster WITH(nolock)
	      LEFT OUTER JOIN ItemRates WITH(nolock) ON ItemMaster.ItemmasterID=ItemRates.ItemMasterID
		          AND ISNULL(ItemRates.isDeleted,0)=0 AND GETDATE() BETWEEN ISNULL(StartDate,'01/01/1900') AND ISNULL(EndDate,'01/12/2999')
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
