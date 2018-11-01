ALTER PROCEDURE GetInvoicePickLists
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