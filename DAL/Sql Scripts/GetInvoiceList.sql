GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceList]    Script Date: 25-12-2018 15:15:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetInvoiceList]
(
	@companyID INT,
	@BranchID INT,
	@UserID INT,
	@InvoiceDateFrom VARCHAR(15)='',
	@InvoiceDateTo VARCHAR(15)='',
	@DeleveryDate VARCHAR(15)=''
)
AS

BEGIN

	IF(ISNULL(@companyID,0)=0)
		RETURN -1


	SELECT CustomerMaster.CustomerMasterID,
	       CustomerMaster.FirstName+' '+CustomerMaster.SurName AS CustomerName,
           CONVERT(VARCHAR(15),Invoices.InvoiceDate,103) AS InvoiceDate,
		   CONVERT(VARCHAR(15),Invoices.DeliveryDate,103) AS DeliveryDate,
		   Invoices.BillNumber,
		   Invoices.NetAmount,
		   Masters.FirstName+''+Masters.LastName AS MasterName,
		   Designers.FirstName+''+Designers.LastName AS DesignerName,
		   Invoices.InvoiceID,
		   Invoices.MobileNumber,
		   Invoices.TotalBasePrice as BasePrice,
		   Invoices.TotalCGST as GST,
		   Invoices.TotalSGST as SGST
		 FROM CustomerMaster WITH(NOLOCK)
		      INNER JOIN Invoices WITH(NOLOCK) ON CustomerMaster.CustomerMasterID=Invoices.CustomerID
			  LEFT OUTER JOIN EmployeeMaster AS Masters WITH(nolock) ON Invoices.MasterID=Masters.EmployeeMasterID AND Masters.CompanyID=@companyID
			  LEFT OUTER JOIN EmployeeMaster AS Designers WITH(nolock) ON Invoices.DesignerID=Designers.EmployeeMasterID AND Designers.CompanyID=@companyID
			WHERE CustomerMaster.CompanyID=@companyID
			    AND Invoices.CompanyID=@companyID
				AND CustomerMaster.BranchID=@BranchID
				AND ISNULL(Invoices.isDeleted,0)=0
				AND (ISNULL(@DeleveryDate,'')='' OR CONVERT(date,Invoices.DeliveryDate)= CONVERT(DATE,@DeleveryDate,103))
				AND (ISNULL(@InvoiceDateTo,'')='' OR CONVERT(date,Invoices.InvoiceDate) BETWEEN CONVERT(DATE,@InvoiceDateFrom,103) AND CONVERT(DATE,@InvoiceDateTo,103))
				FOR JSON PATH

	RETURN 1
END
