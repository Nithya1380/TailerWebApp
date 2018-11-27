GO
/****** Object:  StoredProcedure [dbo].[GetCustomerList]    Script Date: 27-Nov-2018 22:45:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetCustomerList]
(
	@companyID INT,
	@UserID INT
)
AS

BEGIN
	IF(ISNULL(@companyID,0)=0)
		RETURN -1


	SELECT CustomerMaster.CustomerMasterID,
	       FirstName+' '+SurName AS CustomerName,
           MiddleName,
		   Address.MobileNo,
		   Address.HomePhoneNo,
		   Address.EmailID,
		   Address.Address1,
		   Address.Address2,
		   Address.City,
		   Address.State
		 FROM CustomerMaster WITH(NOLOCK),[Address] WITH(NOLOCK)
			WHERE CustomerMaster.CompanyID=@companyID
				AND CustomerMaster.CustomerAddressID=[Address].AddressID
				AND Address.CompanyID=@companyID
				FOR JSON PATH

	RETURN 1
END
