
/****** Object:  StoredProcedure [dbo].[GetInvoiceList]    Script Date: 22-12-2018 12:15:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetInvoiceList]
(
	@companyID INT,
	@BranchID INT,
	@UserID INT
)
AS

BEGIN
	IF(ISNULL(@companyID,0)=0)
		RETURN -1


	SELECT CustomerMaster.CustomerMasterID,
	       CustomerMaster.FirstName+' '+CustomerMaster.SurName AS CustomerName,
           CONVERT(VARCHAR(15),Invoices.InvoiceDate,101) AS InvoiceDate,
		   Invoices.BillNumber,
		   Invoices.NetAmount,
		   Masters.FirstName+''+Masters.LastName AS MasterName,
		   Designers.FirstName+''+Designers.LastName AS DesignerName,
		   Invoices.InvoiceID,
		   Invoices.MobileNumber
		 FROM CustomerMaster WITH(NOLOCK)
		      INNER JOIN Invoices WITH(NOLOCK) ON CustomerMaster.CustomerMasterID=Invoices.CustomerID
			  LEFT OUTER JOIN EmployeeMaster AS Masters WITH(nolock) ON Invoices.MasterID=Masters.EmployeeMasterID AND Masters.CompanyID=@companyID
			  LEFT OUTER JOIN EmployeeMaster AS Designers WITH(nolock) ON Invoices.DesignerID=Designers.EmployeeMasterID AND Designers.CompanyID=@companyID
			WHERE CustomerMaster.CompanyID=@companyID
			    AND Invoices.CompanyID=@companyID
				AND CustomerMaster.BranchID=@BranchID
				FOR JSON PATH

	RETURN 1
END
