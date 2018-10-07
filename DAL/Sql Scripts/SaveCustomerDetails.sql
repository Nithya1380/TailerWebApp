ALTER PROCEDURE [DBO].[SaveCustomerDetails]
(
   @companyID INT,
   @CustomerID INT OUTPUT,
   @CustomerBranchID INT,
   @UserID INT,
   @customerObj VARCHAR(6000)
)

AS

BEGIN
	IF NOT EXISTS(SELECT 1 FROM CompanyMaster WITH(nolock) WHERE CompanyID=@companyID)
	RETURN -1

	IF EXISTS(SELECT 1 FROM OPENJSON(@customerObj) 
               WITH(
					 FirstName VARCHAR(100) '$.Customer.FirstName' ,  
					 SurName   VARCHAR(100) '$.Customer.SurName',
					 BirthDate VARCHAR(15) '$.Customer.BirthDate'
				   )
				 WHERE ISNULL(FirstName,'')='' OR ISNULL(SurName,'')='' OR ISNULL(BirthDate,'')='')
	 RETURN -2

	 IF EXISTS(SELECT 1 FROM CustomerMaster WITH(nolock)
                 CROSS APPLY(SELECT FirstName,SurName FROM OPENJSON(@customerObj) 
								 WITH(
									  FirstName VARCHAR(100) '$.Customer.FirstName' ,  
									  SurName   VARCHAR(100) '$.Customer.SurName'
									)
				            ) AS NewCustomer
		       WHERE CompanyID=@companyID
			     AND CustomerMaster.CustomerMasterID<>@CustomerID
			     AND CustomerMaster.FirstName=NewCustomer.FirstName)
	   RETURN -3

	IF EXISTS(SELECT 1 FROM AccountsMaster WITH(nolock)
	             CROSS APPLY(SELECT CustomerMaster.CustomerMasterID
				              FROM CustomerMaster WITH(nolock)
							    WHERE CustomerMaster.CompanyID=@companyID
								  AND CustomerMaster.CustomerMasterID=AccountsMaster.CustomerMasterID
				  ) AS Cust
                 CROSS APPLY(SELECT AccountCode FROM OPENJSON(@customerObj) 
								 WITH(
									  AccountCode VARCHAR(100) '$.CustomerAccount.AccountCode' 
									)
				            ) AS NewCustomer
		       WHERE CompanyID=@companyID
			     AND AccountsMaster.AccountCode=NewCustomer.AccountCode
				 AND Cust.CustomerMasterID<>@CustomerID
		      )
	   RETURN -4

	   IF EXISTS(SELECT AccountCategory FROM OPENJSON(@customerObj) 
					WITH(AccountCategory VARCHAR(100) '$.CustomerAccount.AccountCategory')
					  WHERE ISNULL(AccountCategory,'')='Supplier'
				 )
		BEGIN
		  IF EXISTS(SELECT 1 FROM OPENJSON(@customerObj) 
               WITH(
					 SupplierCode VARCHAR(100) '$.CustomerSupply.SupplierCode' ,  
					 SupplierName   VARCHAR(100) '$.CustomerSupply.SupplierName',
					 SupplierType VARCHAR(15) '$.CustomerSupply.SupplierType'
				   )
				 WHERE ISNULL(SupplierCode,'')='' OR ISNULL(SupplierName,'')='' OR ISNULL(SupplierType,'')='')
			RETURN -2
		END

	DECLARE @AddressID INT

	SELECT @AddressID=CustomerMaster.CustomerAddressID
	     FROM CustomerMaster WITH(nolock)
		   WHERE CustomerMaster.CompanyID=@companyID
		     AND CustomerMaster.CustomerMasterID=@CustomerID

	IF(ISNULL(@AddressID,0)<>0)
	BEGIN
	  ;WITH Customer_AddressCTE AS
		(
		   SELECT *
		     FROM OPENJSON(@customerObj) 
				  WITH(
						Address1 VARCHAR(100) '$.Customer.Address1' ,  
						Address2   VARCHAR(100) '$.Customer.Address2',
						City    VARCHAR(50) '$.Customer.City',
                        [State]  VARCHAR(30) '$.Customer.State',
                        Pincode VARCHAR(10) '$.Customer.Pincode',
                        OfficePhoneNo VARCHAR(20) '$.Customer.OfficePhoneNo',
                        MobileNo VARCHAR(20) '$.Customer.MobileNo',
                        AlternateNo  VARCHAR(20) '$.Customer.AlternateNo',
                        HomePhoneNo VARCHAR(20) '$.Customer.HomePhoneNo',
                        EmailID VARCHAR(100) '$.Customer.EmailID'
					  )
		)

	   UPDATE Address SET Address1=Customer_AddressCTE.Address1,
                          Address2=Customer_AddressCTE.Address2,
                          City=Customer_AddressCTE.City,
                          [State]=Customer_AddressCTE.[State],
                          Pincode=Customer_AddressCTE.Pincode,
                          OfficePhoneNo=Customer_AddressCTE.OfficePhoneNo,
                          MobileNo=Customer_AddressCTE.MobileNo,
                          AlternateNo=Customer_AddressCTE.AlternateNo,
                          HomePhoneNo=Customer_AddressCTE.HomePhoneNo,
                          EmailID=Customer_AddressCTE.EmailID
		FROM Customer_AddressCTE
		  WHERE [Address].AddressID=@AddressID
		    AND [Address].CompanyID=@companyID
	END
	ELSE
	BEGIN
	  INSERT INTO Address(CompanyID,Address1,Address2,City,State,Pincode,OfficePhoneNo,MobileNo,AlternateNo,HomePhoneNo,EmailID,CreatedOn,CreatedBy)
	  SELECT @companyID,Address1,Address2,City,State,Pincode,OfficePhoneNo,MobileNo,AlternateNo,HomePhoneNo,EmailID,GETDATE(),@UserID
		     FROM OPENJSON(@customerObj) 
				  WITH(
						Address1 VARCHAR(100) '$.Customer.Address1' ,  
						Address2   VARCHAR(100) '$.Customer.Address2',
						City    VARCHAR(50) '$.Customer.City',
                        [State]  VARCHAR(30) '$.Customer.State',
                        Pincode VARCHAR(10) '$.Customer.Pincode',
                        OfficePhoneNo VARCHAR(20) '$.Customer.OfficePhoneNo',
                        MobileNo VARCHAR(20) '$.Customer.MobileNo',
                        AlternateNo  VARCHAR(20) '$.Customer.AlternateNo',
                        HomePhoneNo VARCHAR(20) '$.Customer.HomePhoneNo',
                        EmailID VARCHAR(100) '$.Customer.EmailID'
					  )

		SELECT @AddressID=SCOPE_IDENTITY()
	END

	IF(ISNULL(@CustomerID,0)<>0)
	BEGIN
	   
		;WITH Customer_CTE AS
		(
		   SELECT *
		     FROM OPENJSON(@customerObj) 
				  WITH(
						FirstName VARCHAR(50) '$.Customer.FirstName' ,  
						SurName   VARCHAR(20) '$.Customer.SurName',
						Gender    VARCHAR(10) '$.Customer.Gender',
                        FullName  VARCHAR(100) '$.Customer.FullName',
                        MiddleName VARCHAR(20) '$.Customer.MiddleName',
                        ContactPerson VARCHAR(100) '$.Customer.ContactPerson',
                        BirthDate VARCHAR(15) '$.Customer.BirthDate',
                        OpenDate  VARCHAR(15) '$.Customer.OpenDate',
                        PANNumber VARCHAR(20) '$.Customer.PANNumber',
                        ReferenceNumber VARCHAR(100) '$.Customer.ReferenceNumber',
                        Remarks VARCHAR(100) '$.Customer.Remarks',
                        AnnDate VARCHAR(15) '$.Customer.AnnDate',
                        SRName VARCHAR(50) '$.Customer.SRName',
                        CustomerCardNumber VARCHAR(100) '$.Customer.CustomerCardNumber'
					  )
		)

		UPDATE CustomerMaster SET Gender=Customer_CTE.Gender,
                                  FirstName=Customer_CTE.FirstName,
                                  MiddleName=Customer_CTE.MiddleName,
                                  SurName=Customer_CTE.SurName,
                                  ContactPerson=Customer_CTE.ContactPerson,
                                  BirthDate=Customer_CTE.BirthDate,
                                  OpenDate=Customer_CTE.OpenDate,
                                  PANNumber=Customer_CTE.PANNumber,
                                  ReferenceNumber=Customer_CTE.ReferenceNumber,
                                  Remarks=Customer_CTE.Remarks,
                                  AnnDate=Customer_CTE.AnnDate,
                                  SRName=Customer_CTE.SRName,
                                  CustomerCardNumber=Customer_CTE.CustomerCardNumber,
								  CustomerAddressID=@AddressID
			FROM Customer_CTE
			  WHERE CustomerMaster.CompanyID=@companyID
		        AND CustomerMaster.CustomerMasterID=@CustomerID

		;WITH CustomerAcct_CTE AS
		(
		   SELECT *
		     FROM OPENJSON(@customerObj) 
				  WITH(
						AccountCode VARCHAR(20) '$.CustomerAccount.AccountCode',
                        AccountName VARCHAR(100) '$.CustomerAccount.AccountName',
                        IsCommonAccount BIT '$.CustomerAccount.IsCommonAccount',
                        IsActive BIT '$.CustomerAccount.IsActive',
                        AccountType VARCHAR(50) '$.CustomerAccount.AccountType',
                        OpeningBalance VARCHAR(15) '$.CustomerAccount.OpeningBalance',
                        ClosingBalance VARCHAR(15) '$.CustomerAccount.ClosingBalance',
                        ParentGroup VARCHAR(50) '$.CustomerAccount.ParentGroup',
                        AccountCategory VARCHAR(50) '$.CustomerAccount.AccountCategory',
                        AccountCreatedDate VARCHAR(15) '$.CustomerAccount.AccountCreatedDate',
                        PartyAlert VARCHAR(50) '$.CustomerAccount.PartyAlert',
                        IsTDSApplicable BIT '$.CustomerAccount.IsTDSApplicable',
                        TDSCategory VARCHAR(50) '$.CustomerAccount.TDSCategory',
                        TDSDepriciation VARCHAR(50) '$.CustomerAccount.TDSDepriciation',
                        [Default] VARCHAR(50) '$.CustomerAccount.Default',
                        [Reverse] VARCHAR(50) '$.CustomerAccount.Reverse',
                        [Sequence] VARCHAR(20) '$.CustomerAccount.Sequence',
                        Sh6Group VARCHAR(50) '$.CustomerAccount.Sh6Group',
                        Sh6AccountNumber VARCHAR(50) '$.CustomerAccount.Sh6AccountNumber'
					  )
		)

		UPDATE AccountsMaster SET AccountCode=CustomerAcct_CTE.AccountCode,
                                  AccountName=ISNULL(CustomerAcct_CTE.AccountName,''),
                                  IsCommonAccount=CustomerAcct_CTE.IsCommonAccount,
                                  IsActive=CustomerAcct_CTE.IsActive,
                                  AccountType=CustomerAcct_CTE.AccountType,
                                  OpeningBalance=CustomerAcct_CTE.OpeningBalance,
                                  ClosingBalance=CustomerAcct_CTE.ClosingBalance,
                                  ParentGroup=CustomerAcct_CTE.ParentGroup,
                                  AccountCategory=CustomerAcct_CTE.AccountCategory,
                                  AccountCreatedDate=CustomerAcct_CTE.AccountCreatedDate,
                                  PartyAlert=CustomerAcct_CTE.PartyAlert,
                                  IsTDSApplicable=CustomerAcct_CTE.IsTDSApplicable,
                                  TDSCategory=CustomerAcct_CTE.TDSCategory,
                                  TDSDepriciation=CustomerAcct_CTE.TDSDepriciation,
                                  [Default]=CustomerAcct_CTE.[Default],
                                  [Reverse]=CustomerAcct_CTE.[Reverse],
                                  [Sequence]=CustomerAcct_CTE.[Sequence],
                                  Sh6Group=CustomerAcct_CTE.Sh6Group,
                                  Sh6AccountNumber=CustomerAcct_CTE.Sh6AccountNumber
			FROM CustomerAcct_CTE
			  WHERE AccountsMaster.CompanyID=@CompanyID
			    AND AccountsMaster.CustomerMasterID=@CustomerID
        
		IF EXISTS(SELECT AccountCategory FROM OPENJSON(@customerObj) 
					WITH(AccountCategory VARCHAR(100) '$.CustomerAccount.AccountCategory')
					  WHERE ISNULL(AccountCategory,'')='Supplier'
				 )
		BEGIN
			;WITH CustomerSupply_CTE AS
			(
			  SELECT *
				FROM OPENJSON(@customerObj) 
					  WITH(
							SupplierCode VARCHAR(20) '$.CustomerSupply.SupplierCode',
                            SupplierName VARCHAR(100) '$.CustomerSupply.SupplierName',
                            SupplierType VARCHAR(20) '$.CustomerSupply.SupplierType',
                            SupplierCategory  VARCHAR(50) '$.CustomerSupply.SupplierCategory',
                            CSTNumber VARCHAR(30) '$.CustomerSupply.CSTNumber',
                            CSTDate VARCHAR(15) '$.CustomerSupply.CSTDate',
                            STDate VARCHAR(15) '$.CustomerSupply.STDate',
                            STNumber VARCHAR(30) '$.CustomerSupply.STNumber',
                            GSTINNumber VARCHAR(30) '$.CustomerSupply.GSTINNumber',
                            TINNumber VARCHAR(30) '$.CustomerSupply.TINNumber',
                            VATNumber VARCHAR(30) '$.CustomerSupply.VATNumber',
                            SupplierPANNumber VARCHAR(30) '$.CustomerSupply.SupplierPANNumber',
                            LessVATPercent VARCHAR(15) '$.CustomerSupply.LessVATPercent',
                            MarkUpPercent VARCHAR(15) '$.CustomerSupply.MarkUpPercent',
                            MarkDownPercent VARCHAR(15) '$.CustomerSupply.MarkDownPercent',
                            CreditDays VARCHAR(15) '$.CustomerSupply.CreditDays'
						  ) 
			)

			 UPDATE CustomerSupplierMaster SET SupplierCode=CustomerSupply_CTE.SupplierCode,
                                               SupplierName=CustomerSupply_CTE.SupplierName,
                                               SupplierType=CustomerSupply_CTE.SupplierType,
                                               SupplierCategory=CustomerSupply_CTE.SupplierCategory,
                                               CSTNumber=CustomerSupply_CTE.CSTNumber,
                                               CSTDate=CustomerSupply_CTE.CSTDate,
                                               STDate=CustomerSupply_CTE.STDate,
                                               STNumber=CustomerSupply_CTE.STNumber,
                                               GSTINNumber=CustomerSupply_CTE.GSTINNumber,
                                               TINNumber=CustomerSupply_CTE.TINNumber,
                                               VATNumber=CustomerSupply_CTE.VATNumber,
                                               SupplierPANNumber=CustomerSupply_CTE.SupplierPANNumber,
                                               LessVATPercent=CustomerSupply_CTE.LessVATPercent,
                                               MarkUpPercent=CustomerSupply_CTE.MarkUpPercent,
                                               MarkDownPercent=CustomerSupply_CTE.MarkDownPercent,
                                               CreditDays=CustomerSupply_CTE.CreditDays
			   FROM CustomerSupply_CTE
				 WHERE CustomerSupplierMaster.CompanyID=@CompanyID
				   AND CustomerSupplierMaster.CustomerMasterID=@CustomerID
		END
	END
	ELSE
	BEGIN
	   INSERT INTO CustomerMaster(CompanyID,CreatedBy,CreatedOn,Gender,FullName,FirstName,MiddleName,SurName,ContactPerson,BirthDate,
                                  OpenDate,CustomerAddressID,PANNumber,ReferenceNumber,Remarks,AnnDate,SRName,CustomerCardNumber)
		SELECT @companyID,@UserID,GETDATE(),Gender,FullName,FirstName,MiddleName,SurName,ContactPerson,BirthDate,
               OpenDate,@AddressID,PANNumber,ReferenceNumber,Remarks,AnnDate,SRName,CustomerCardNumber
		     FROM OPENJSON(@customerObj) 
				  WITH(
						FirstName VARCHAR(50) '$.Customer.FirstName' ,  
						SurName   VARCHAR(20) '$.Customer.SurName',
						Gender    VARCHAR(10) '$.Customer.Gender',
                        FullName  VARCHAR(100) '$.Customer.FullName',
                        MiddleName VARCHAR(20) '$.Customer.MiddleName',
                        ContactPerson VARCHAR(100) '$.Customer.ContactPerson',
                        BirthDate VARCHAR(15) '$.Customer.BirthDate',
                        OpenDate  VARCHAR(15) '$.Customer.OpenDate',
                        PANNumber VARCHAR(20) '$.Customer.PANNumber',
                        ReferenceNumber VARCHAR(100) '$.Customer.ReferenceNumber',
                        Remarks VARCHAR(100) '$.Customer.Remarks',
                        AnnDate VARCHAR(15) '$.Customer.AnnDate',
                        SRName VARCHAR(50) '$.Customer.SRName',
                        CustomerCardNumber VARCHAR(100) '$.Customer.CustomerCardNumber'
					  )

		SELECT @CustomerID=SCOPE_IDENTITY()

		INSERT INTO AccountsMaster(CompanyID,CustomerMasterID,CreatedBy,CreatedOn,AccountCode,AccountName,IsCommonAccount,IsActive,
                                   AccountType,OpeningBalance,ClosingBalance,ParentGroup,AccountCategory,AccountCreatedDate,PartyAlert,
                                   IsTDSApplicable,TDSCategory,TDSDepriciation,[Default],[Reverse],[Sequence],Sh6Group,Sh6AccountNumber)
			SELECT @companyID,@CustomerID,@UserID,GETDATE(),AccountCode,ISNULL(AccountName,''),IsCommonAccount,IsActive,
                   AccountType,OpeningBalance,ClosingBalance,ParentGroup,AccountCategory,AccountCreatedDate,PartyAlert,
                   IsTDSApplicable,TDSCategory,TDSDepriciation,[Default],[Reverse],[Sequence],Sh6Group,Sh6AccountNumber
		     FROM OPENJSON(@customerObj) 
				  WITH(
						AccountCode VARCHAR(20) '$.CustomerAccount.AccountCode',
                        AccountName VARCHAR(100) '$.CustomerAccount.AccountName',
                        IsCommonAccount BIT '$.CustomerAccount.IsCommonAccount',
                        IsActive BIT '$.CustomerAccount.IsActive',
                        AccountType VARCHAR(50) '$.CustomerAccount.AccountType',
                        OpeningBalance VARCHAR(15) '$.CustomerAccount.OpeningBalance',
                        ClosingBalance VARCHAR(15) '$.CustomerAccount.ClosingBalance',
                        ParentGroup VARCHAR(50) '$.CustomerAccount.ParentGroup',
                        AccountCategory VARCHAR(50) '$.CustomerAccount.AccountCategory',
                        AccountCreatedDate VARCHAR(15) '$.CustomerAccount.AccountCreatedDate',
                        PartyAlert VARCHAR(50) '$.CustomerAccount.PartyAlert',
                        IsTDSApplicable BIT '$.CustomerAccount.IsTDSApplicable',
                        TDSCategory VARCHAR(50) '$.CustomerAccount.TDSCategory',
                        TDSDepriciation VARCHAR(50) '$.CustomerAccount.TDSDepriciation',
                        [Default] VARCHAR(50) '$.CustomerAccount.Default',
                        [Reverse] VARCHAR(50) '$.CustomerAccount.Reverse',
                        [Sequence] VARCHAR(20) '$.CustomerAccount.Sequence',
                        Sh6Group VARCHAR(50) '$.CustomerAccount.Sh6Group',
                        Sh6AccountNumber VARCHAR(50) '$.CustomerAccount.Sh6AccountNumber'
					  )

		 INSERT INTO CustomerSupplierMaster(CustomerMasterID,CompanyID,CreatedBy,CreatedOn,SupplierCode,SupplierName,SupplierType,
                                            SupplierCategory,CSTNumber,CSTDate,STDate,STNumber,GSTINNumber,TINNumber,VATNumber,
											SupplierPANNumber,LessVATPercent,MarkUpPercent,MarkDownPercent,CreditDays)
			SELECT @CustomerID,@companyID,@UserID,GETDATE(),SupplierCode,SupplierName,SupplierType,
                   SupplierCategory,CSTNumber,CSTDate,STDate,STNumber,GSTINNumber,TINNumber,VATNumber,
			       SupplierPANNumber,LessVATPercent,MarkUpPercent,MarkDownPercent,CreditDays
				FROM OPENJSON(@customerObj) 
					  WITH(
							SupplierCode VARCHAR(20) '$.CustomerSupply.SupplierCode',
                            SupplierName VARCHAR(100) '$.CustomerSupply.SupplierName',
                            SupplierType VARCHAR(20) '$.CustomerSupply.SupplierType',
                            SupplierCategory  VARCHAR(50) '$.CustomerSupply.SupplierCategory',
                            CSTNumber VARCHAR(30) '$.CustomerSupply.CSTNumber',
                            CSTDate VARCHAR(15) '$.CustomerSupply.CSTDate',
                            STDate VARCHAR(15) '$.CustomerSupply.STDate',
                            STNumber VARCHAR(30) '$.CustomerSupply.STNumber',
                            GSTINNumber VARCHAR(30) '$.CustomerSupply.GSTINNumber',
                            TINNumber VARCHAR(30) '$.CustomerSupply.TINNumber',
                            VATNumber VARCHAR(30) '$.CustomerSupply.VATNumber',
                            SupplierPANNumber VARCHAR(30) '$.CustomerSupply.SupplierPANNumber',
                            LessVATPercent VARCHAR(15) '$.CustomerSupply.LessVATPercent',
                            MarkUpPercent VARCHAR(15) '$.CustomerSupply.MarkUpPercent',
                            MarkDownPercent VARCHAR(15) '$.CustomerSupply.MarkDownPercent',
                            CreditDays VARCHAR(15) '$.CustomerSupply.CreditDays'
						  ) 
	END
	RETURN 1				 
END