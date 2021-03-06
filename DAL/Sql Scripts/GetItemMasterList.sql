GO
/****** Object:  StoredProcedure [dbo].[GetItemMasterList]    Script Date: 27-Nov-2018 22:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetItemMasterList]
(
	@companyID INT,
	@UserID INT,
	@ItemMasterID INT=0,
	@InvoiceID INT = 0
)
AS

BEGIN
	IF(ISNULL(@companyID,0)=0)
		RETURN -1

   IF (ISNULL(@ItemMasterID,0)>0)
   BEGIN
		SELECT ItemmasterID,
			   ItemCode,
			   ItemDescription,
			   ItemGroup,
			   ItemAlias,
			   ItemPrice,
			   TotalGST, 
			   SGSTPer,
			   SGST, 
			   CGSTPer, 
			   CGST, 
			   BillAmt
			 FROM ItemMaster WITH(NOLOCK)
				WHERE ItemMaster.CompanyID=@companyID
				  AND ItemMaster.ItemmasterID=@ItemMasterID
					FOR JSON PATH
   END
   ELSE IF(ISNULL(@InvoiceID,0)>0)
   BEGIN
		SELECT ItemMaster.ItemmasterID,
			   ItemCode,
			   ItemDescription,
			   ItemGroup,
			   ItemAlias,
			   ItemPrice,
			   TotalGST, 
			   SGSTPer,
			   SGST, 
			   CGSTPer, 
			   CGST, 
			   BillAmt,
			   ISNULL(tempInvoice.ItemQuantity,0) as ItemQuantity
			 FROM ItemMaster WITH(NOLOCK)
				OUTER APPLY(
					SELECt InvoiceDetails.ItemMasterID, SUM(InvoiceDetails.ItemQuantity) as ItemQuantity FROM InvoiceDetails WITH(NOLOCK)
							WHERE InvoiceDetails.CompanyID = @companyID AND InvoiceDetails.InvoiceID = @InvoiceID
								AND InvoiceDetails.ItemMasterID = ItemMaster.ItemmasterID
						GROUP BY InvoiceDetails.ItemMasterID
				) tempInvoice
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
			   ItemPrice,
			   TotalGST, 
			   SGSTPer,
			   SGST, 
			   CGSTPer, 
			   CGST, 
			   BillAmt
			 FROM ItemMaster WITH(NOLOCK)
				WHERE ItemMaster.CompanyID=@companyID
					FOR JSON PATH
	END
	

	RETURN 1
END
