
/****** Object:  StoredProcedure [dbo].[GetCustomerList]    Script Date: 30-12-2018 21:54:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetCustomerList]
(
	@companyID INT,
	@UserID INT,
	@BirthDate VARCHAR(15)=''
)
AS

BEGIN
SET DATEFORMAT dmy

	IF(ISNULL(@companyID,0)=0)
		RETURN -1


	SELECT CustomerMaster.CustomerMasterID,
	       isnull(FirstName, '')+' '+ isnull(MiddleName, '') +' '+isnull(SurName, '') AS CustomerName,
           MiddleName,
		   Address.MobileNo,
		   Address.HomePhoneNo,
		   Address.EmailID,
		   Address.Address1,
		   Address.Address2,
		   Address.City,
		   Address.State,
		   AccountsMaster.AccountCode,
		   CONVERT(VARCHAR,CustomerMaster.BirthDate,103) as BirthDate
		 FROM CustomerMaster WITH(NOLOCK)
		LEFT OUTER JOIN  AccountsMaster WITH(NOLOCK)
			ON AccountsMaster.CompanyID = @companyID AND AccountsMaster.CustomerMasterID = CustomerMaster.CustomerMasterID
		 ,[Address] WITH(NOLOCK)
			WHERE CustomerMaster.CompanyID=@companyID
				AND CustomerMaster.CustomerAddressID=[Address].AddressID
				AND Address.CompanyID=@companyID
				AND (ISDATE(@BirthDate)=0 OR FORMAT(BirthDate,'dd/MM')=FORMAT(CONVERT(date,@BirthDate),'dd/MM'))
				FOR JSON PATH

	RETURN 1
END
