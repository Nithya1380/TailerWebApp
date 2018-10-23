ALTER PROCEDURE SearchCustomer
(
  @CompanyID INT,
  @BranchID INT,
  @UserID INT=NULL,
  @SearchText VARCHAR(500)=''
)
AS

BEGIN
   SELECT CustomerMaster.CustomerMasterID,CustomerMaster.FirstName+' '+CustomerMaster.SurName+'('+AccountsMaster.AccountCode+')' AS CustomerName
     FROM CustomerMaster WITH(nolock),AccountsMaster WITH(nolock)
	   WHERE CustomerMaster.CompanyID=@CompanyID
	     AND AccountsMaster.CompanyID=@CompanyID
		 AND CustomerMaster.CustomerMasterID=AccountsMaster.CustomerMasterID
	     --AND CustomerMaster.BranchID=@BranchID
		 AND (AccountsMaster.AccountCode LIKE '%'+@SearchText+'%'
		      OR CustomerMaster.FirstName LIKE '%'+@SearchText+'%'
			  OR CustomerMaster.SurName LIKE '%'+@SearchText+'%'
		  )
		  FOR JSON PATH

	RETURN 1
END