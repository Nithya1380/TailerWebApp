GO
/****** Object:  StoredProcedure [dbo].[GetCustomerDetails]    Script Date: 27-Nov-2018 22:45:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetCustomerDetails]
(
	@companyID INT,
	@CustomerID INT,
	@UserID INT
)
AS

BEGIN
	--IF(ISNULL(@CustomerID,0)=0)
	--	RETURN -1


	SELECT CustomerMasterID AS CustomerID,
		   FullName,
		   FirstName,
		   MiddleName,
		   SurName,
		   ContactPerson,
		   CONVERT(VARCHAR,BirthDate,103) AS BirthDate,
		   CONVERT(VARCHAR,OpenDate,103) AS OpenDate,
		   PANNumber,
		   ReferenceNumber,
		   Remarks,
		   CONVERT(VARCHAR,AnnDate,103) AS AnnDate,
		   SRName,
		   CustomerCardNumber,
		   Address1,
		   Address2,
		   City,
		   [State],
		   Pincode,
		   MobileNo,
		   HomePhoneNo,
		   EmailID,
		   Gender
		 FROM CustomerMaster WITH(NOLOCK),[Address] WITH(NOLOCK)
			WHERE CustomerMaster.CompanyID=@companyID
				AND CustomerMaster.CustomerAddressID=[Address].AddressID
				AND Address.CompanyID=@companyID
				AND CustomerMaster.CustomerMasterID=@CustomerID
					FOR JSON PATH,WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES

		SELECT  AccountCode,
				AccountName,
				ISNULL(IsCommonAccount,0) as IsCommonAccount,
				ISNULL(IsActive,0) as IsActive,
				AccountType,
				OpeningBalance,
				ClosingBalance,
				ParentGroup,
				AccountCategory,
				CONVERT(VARCHAR,AccountCreatedDate,101) AS AccountCreatedDate,
				PartyAlert,
				ISNULL(IsTDSApplicable,0) as IsTDSApplicable,
				TDSCategory,
				TDSDepriciation,
				[Default],
				[Reverse],
				[Sequence],
				Sh6Group,
				Sh6AccountNumber
			 FROM AccountsMaster WITH(NOLOCK)
				WHERE AccountsMaster.CompanyID=@companyID
					AND AccountsMaster.CustomerMasterID=@CustomerID
						FOR JSON PATH,WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES

		SELECT CustomerPhoto
			 FROM CustomerPhoto WITH(NOLOCK)
				WHERE CustomerPhoto.CompanyID=@companyID
					AND CustomerPhoto.CustomerMasterID=@CustomerID
						

		SELECT BranchID,'' AS BranchName
			 FROM CustomerBranchMaster WITH(NOLOCK)
			WHERE CustomerBranchMaster.CompanyID=@companyID
				AND CustomerBranchMaster.CustomerMasterID=@CustomerID
					FOR JSON PATH,WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES

		SELECT  SupplierCode,
				SupplierName,
				SupplierType,
				SupplierCategory,
				CSTNumber,
		        CONVERT(VARCHAR,CSTDate,101) AS CSTDate,
				CONVERT(VARCHAR,STDate,101) AS STDate ,
				STNumber,
				GSTINNumber,
				TINNumber,
				VATNumber,
				SupplierPANNumber,
				LessVATPercent,
				MarkUpPercent,
				MarkDownPercent,
				CreditDays
			 FROM CustomerSupplierMaster WITH(NOLOCK)
			WHERE CustomerSupplierMaster.CompanyID=@companyID
				AND CustomerSupplierMaster.CustomerMasterID=@CustomerID
					FOR JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES

	RETURN 1
END
