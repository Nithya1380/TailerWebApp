CREATE PROCEDURE GetDashboard
(
  @Company INT,
  @user INT,
  @BranchID INT
)

AS

BEGIN 
   IF(ISNULL(@Company,0)=0)
     RETURN -1

   DECLARE @DelivaryOfTheDay INT,
           @BirthDay INT,
		   @RecentInvoices INT

	SELECT @DelivaryOfTheDay=COUNT(*)
	  FROM Invoices WITH(nolock)
	    WHERE CompanyID=@Company
		  AND ISNULL(isDeleted,0)=0
		  AND CONVERT(date,DeliveryDate)=CONVERT(date,GETDATE())

	SELECT @BirthDay=COUNT(*)
	  FROM CustomerMaster WITH(nolock)
	    WHERE CompanyID=@Company
		  AND CONVERT(date,BirthDate)=CONVERT(date,GETDATE())

	SELECT @RecentInvoices=COUNT(*)
	  FROM Invoices WITH(nolock)
	    WHERE CompanyID=@Company
		  AND ISNULL(isDeleted,0)=0
		  AND InvoiceDate IS NOT NULL
		  AND InvoiceDate BETWEEN DATEADD(MONTH,-1,GETDATE()) AND DATEADD(DAY,1,GETDATE())

	SELECT @DelivaryOfTheDay AS DelivaryOfTheDay,
           @BirthDay AS BirthDay,
		   @RecentInvoices AS RecentInvoices
		   FOR JSON PATH,WITHOUT_ARRAY_WRAPPER 

	SELECT BranchID,BranchName,BranchCode,BranchDivision
	  FROM BranchDetails WITH(nolock)
	    WHERE CompanyID=@Company
		  AND ISNULL(isDeleted,0)=0
		  FOR JSON PATH

	RETURN 1
	   
END