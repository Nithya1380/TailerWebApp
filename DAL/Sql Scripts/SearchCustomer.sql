GO
/****** Object:  StoredProcedure [dbo].[SearchCustomer]    Script Date: 27-Nov-2018 22:46:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SearchCustomer]
(
  @CompanyID INT,
  @BranchID INT,
  @UserID INT=NULL,
  @SearchText VARCHAR(500)=''
)
AS

BEGIN
   SELECT CustomerMaster.CustomerMasterID,CustomerMaster.FirstName+' '+CustomerMaster.SurName+'('+AccountsMaster.AccountCode+')' AS CustomerName,
		AccountsMaster.AccountCode as CustomerMoNumber,
		CustomerMaster.FirstName+' '+CustomerMaster.SurName as Customer
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
