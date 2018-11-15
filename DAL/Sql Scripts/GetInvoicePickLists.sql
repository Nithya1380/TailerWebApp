
/****** Object:  StoredProcedure [dbo].[GetInvoicePickLists]    Script Date: 13-11-2018 23:22:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetInvoicePickLists]
(
   @companyID INT,
   @CustomerID INT,
   @UserID INT
)

AS

BEGIN
  EXEC GetPickLists @companyID, @UserID, 'AccountSeries'

  EXEC GetPickLists @companyID, @UserID, 'InvoiceLessCategory'

  EXEC GetPickLists @companyID, @UserID, 'InvoiceTaxCategory'

  EXEC GetPickLists @companyID, @UserID, 'InvoicePaymentMethod'

  SELECT EmployeeMasterID,FirstName+' '+LastName AS EmployeeName
    FROM EmployeeMaster WITH(nolock)
	  WHERE CompanyID=@companyID
	    AND ISNULL(isDeleted,0)=0
		AND ISNULL(Position,'')='Master'

	SELECT EmployeeMasterID,FirstName+' '+LastName AS EmployeeName
    FROM EmployeeMaster WITH(nolock)
	  WHERE CompanyID=@companyID
	    AND ISNULL(isDeleted,0)=0
		AND ISNULL(Position,'')='Designer'
		  FOR JSON PATH

	SELECT EmployeeMasterID,FirstName+' '+LastName AS EmployeeName
    FROM EmployeeMaster WITH(nolock)
	  WHERE CompanyID=@companyID
	    AND ISNULL(isDeleted,0)=0
		AND ISNULL(Position,'')='SalesRep'
		 FOR JSON PATH

	RETURN 1

END