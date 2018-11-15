
/****** Object:  StoredProcedure [dbo].[AddNewCustomer]    Script Date: 13-11-2018 23:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AddNewCustomer]
(
   @companyID INT,
   @UserID INT,
   @UserBranchID INT,
   @customerObj VARCHAR(2000),
   @customerAccountObj VARCHAR(2000)
)

AS

BEGIN
   IF NOT EXISTS(SELECT 1 FROM CompanyMaster WITH(nolock) WHERE CompanyID=@companyID)
	RETURN -1
	  

   IF EXISTS(SELECT 1 FROM OPENJSON(@customerObj) 
               WITH(
					 FirstName VARCHAR(100) '$.FirstName' ,  
					 SurName   VARCHAR(100) '$.SurName',
					 BirthDate VARCHAR(15) '$.BirthDate'

				   ),OPENJSON(@customerAccountObj) 
						WITH(
							 AccountCode VARCHAR(100) '$.AccountCode' 
						)
				 WHERE ISNULL(FirstName,'')='' OR ISNULL(SurName,'')='' OR ISNULL(BirthDate,'')='' OR ISNULL(AccountCode,'')='')
	 RETURN -2

  IF EXISTS(SELECT 1 FROM CustomerMaster WITH(nolock)
                 CROSS APPLY(SELECT FirstName,SurName FROM OPENJSON(@customerObj) 
								 WITH(
									  FirstName VARCHAR(100) '$.FirstName' ,  
									  SurName   VARCHAR(100) '$.SurName'
									)
				            ) AS NewCustomer
		       WHERE CompanyID=@companyID
			     AND CustomerMaster.FirstName=NewCustomer.FirstName)
	   RETURN -3

	IF EXISTS(SELECT 1 FROM AccountsMaster WITH(nolock) 
                 CROSS APPLY(SELECT AccountCode FROM OPENJSON(@customerAccountObj) 
								 WITH(
									  AccountCode VARCHAR(100) '$.AccountCode' 
									)
				            ) AS NewCustomer
		       WHERE CompanyID=@companyID
			     AND AccountsMaster.AccountCode=NewCustomer.AccountCode)
	   RETURN -4
	   	 

	DECLARE @AddressID INT,
	        @CustomerMasterID INT

	IF EXISTS(SELECT 1 FROM OPENJSON(@customerObj) 
               WITH(
					 Address1 VARCHAR(50) '$.Address1' ,  
					 Address2 VARCHAR(50) '$.Address2',
					 City VARCHAR(20) '$.City',
					 State VARCHAR(20) '$.State',
					 Pincode VARCHAR(20) '$.Pincode'
				   )
				 WHERE ISNULL(Address1,'')<>'' OR ISNULL(Address2,'')<>'' OR ISNULL(City,'')<>'' OR ISNULL(State,'')<>'' OR ISNULL(Pincode,'')<>'')
	BEGIN
	   INSERT INTO Address(CompanyID,Address1,Address2,City,State,Pincode,MobileNo,HomePhoneNo,EmailID,CreatedOn,CreatedBy)
		SELECT @companyID,Address1,Address2,City,State,Pincode,MobileNo,HomePhoneNo,EmailID,GETDATE(),@UserID
		  FROM OPENJSON(@customerObj) 
               WITH(
					 Address1 VARCHAR(50) '$.FirstName' ,  
					 Address2 VARCHAR(50) '$.Address2',
					 City VARCHAR(20) '$.City',
					 State VARCHAR(20) '$.State',
					 Pincode VARCHAR(20) '$.Pincode',
					 MobileNo VARCHAR(20) '$.MobileNo',
					 HomePhoneNo VARCHAR(20) '$.HomePhoneNo',
					 EmailID VARCHAR(20) '$.EmailID'
				   )

		 SET @AddressID=SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
	   INSERT INTO Address(CompanyID,CreatedOn,CreatedBy)
	   SELECT @companyID,GETDATE(),@UserID

	   SET @AddressID=SCOPE_IDENTITY()
	END

	INSERT INTO CustomerMaster(CompanyID,BranchID,Gender,FullName,FirstName,SurName,BirthDate,CustomerAddressID,CreatedOn,CreatedBy)
	SELECT @companyID,@UserBranchID,Gender,FirstName+' '+SurName,FirstName,SurName,BirthDate,@AddressID,GETDATE(),@UserID 
	 FROM OPENJSON(@customerObj) 
		WITH(
			FirstName VARCHAR(100) '$.FirstName' ,  
			SurName   VARCHAR(100) '$.SurName',
			Gender   VARCHAR(10) '$.Gender',
			BirthDate VARCHAR(15) '$.BirthDate'
		)

	SET @CustomerMasterID=SCOPE_IDENTITY()

	IF(ISNULL(@CustomerMasterID,0)<>0)
	BEGIN
		INSERT INTO AccountsMaster(CompanyID,CustomerMasterID,AccountCode,AccountCategory,AccountName,CreatedBy,CreatedOn)
		SELECT @companyID,@CustomerMasterID,AccountCode,AccountCategory,'',@UserID,GETDATE()
			 FROM OPENJSON(@customerAccountObj) 
				WITH(
						AccountCode VARCHAR(20) '$.AccountCode', 
						AccountCategory VARCHAR(50) '$.AccountCategory'
					)

		INSERT INTO CustomerSupplierMaster(CustomerMasterID,CompanyID,CreatedBy,CreatedOn)
		SELECT @CustomerMasterID,@companyID,@UserID,GETDATE()
	END

	RETURN 1
END