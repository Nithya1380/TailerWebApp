GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceList]    Script Date: 22-12-2018 11:21:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetInvoiceDetails]
(
	@companyID INT,
	@BranchID INT,
	@UserID INT,
	@InvoiceID INT
)
AS

BEGIN
	IF(ISNULL(@companyID,0)=0 OR ISNULL(@InvoiceID,0)=0)
		RETURN -1


	SELECT CustomerMaster.CustomerMasterID,
	       CustomerMaster.FirstName+' '+CustomerMaster.SurName AS CustomerName,
           CONVERT(VARCHAR(15),Invoices.InvoiceDate,103) AS InvoiceDate,
		   Invoices.BillNumber,
		   Invoices.NetAmount,
		   Masters.FirstName+' '+Masters.LastName AS MasterName,
		   Designers.FirstName+' '+Designers.LastName AS DesignerName,
		   SelsReps.FirstName+' '+SelsReps.LastName AS SelsRepsName,
		   InvoiceSeries,
		   MobileNumber,
	       CONVERT(VARCHAR(15),TrailDate,103) AS TrailDate,
		   FORMAT(TrailTime,'HH:mm') AS TrailTime,
		   CONVERT(VARCHAR(15),DeliveryDate,103) AS DeliveryDate,
		   FORMAT(DeliveryTime,'HH:mm') AS DeliveryTime,
		   PaymentNumber,
		   LessRs,
           LessRsAmount,
           Invoices.Remarks,
		   Invoices.RoundOnOff,
		    Invoices.TotalAmount
		 FROM CustomerMaster WITH(NOLOCK)
		      INNER JOIN Invoices WITH(NOLOCK) ON CustomerMaster.CustomerMasterID=Invoices.CustomerID
			  LEFT OUTER JOIN EmployeeMaster AS Masters WITH(nolock) ON Invoices.MasterID=Masters.EmployeeMasterID AND Masters.CompanyID=@companyID
			  LEFT OUTER JOIN EmployeeMaster AS Designers WITH(nolock) ON Invoices.DesignerID=Designers.EmployeeMasterID AND Designers.CompanyID=@companyID
			  LEFT OUTER JOIN EmployeeMaster AS SelsReps WITH(nolock) ON Invoices.SalesRepID=SelsReps.EmployeeMasterID AND SelsReps.CompanyID=@companyID
			WHERE CustomerMaster.CompanyID=@companyID
			    AND Invoices.CompanyID=@companyID
				AND CustomerMaster.BranchID=@BranchID
				AND Invoices.InvoiceID=@InvoiceID
				FOR JSON PATH, WITHOUT_ARRAY_WRAPPER 

	SELECT InvoiceDetailID, 
	       InvoiceDetails.ItemCode,
           InvoiceDetails.ItemDescription,
           ItemQuantity,
           InvoiceDetails.ItemPrice,
           ItemDiscount,
           InvoiceDetails.GST,
           InvoiceDetails.SGST,
           AmountPending,
		   ItemDiscountPer,
		   InvoiceDetails.GSTPer,
		   InvoiceDetails.SGSTPer
	  FROM InvoiceDetails WITH(nolock)
	       INNER JOIN ItemMaster WITH(nolock) ON InvoiceDetails.ItemMasterID=ItemMaster.ItemmasterID
	    WHERE InvoiceID=@InvoiceID
		  AND InvoiceDetails.CompanyID=@companyID
		  AND ItemMaster.CompanyID=@companyID
		    FOR JSON PATH

	RETURN 1
END
