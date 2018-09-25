BEGIN TRAN
   INSERT INTO HomePages(HomePageName,HomePageURL)
   SELECT 'Admin Home Page','UI/Admin/AdminHome.aspx' UNION
   SELECT 'Tailer Home Page','UI/Tailer/TailerHome.aspx'
ROLLBACK TRAN

--Create Company
BEGIN TRAN
   INSERT INTO CompanyMaster(CompanyName,CompanyCode,AddressID,CreatedBy,CreatedOn)
   SELECT 'Test Company','TC',NULL,NULL,GETDATE()
ROLLBACK TRAN

--Create Role
BEGIN TRAN
   INSERT INTO Roles(CompanyID,RoleName,HomePage)
   SELECT 1,'Tailer Role',2
ROLLBACK TRAN

--Create USers
BEGIN TRAN
   INSERT INTO users(CompanyID,LoginID,[password],RoleID,[Status])
   SELECT 1,'nithya.mach@gmail.com',0x70774F6D7868467A4F6A6F3D,1,'Active'
ROLLBACK TRAN

--Create a Customer
BEGIN TRAN
  DECLARE @AddressID INT
  INSERT INTO Address(Address1,Address2,MobileNo,EmailID,HomePhoneNo,CompanyID)
  VALUES('391 County Rd 3386','391 Brooks, Jennifer Rd 3386','974256123','test@gmail.com','123456789',1)
  SET @AddressID=SCOPE_IDENTITY()

  INSERT INTO CustomerMaster(CustomerAddressID,CompanyID,Gender,FirstName,SurName)
  SELECT @AddressID,1,'Male','Test Name','Test Sur'
ROLLBACK TRAN


BEGIN TRAN
    DECLARE @PickID INT
	--Executed
	INSERT INTO PickListMaster(PickListName)
	SELECT 'AccountCategory'

	select @PickID=SCOPE_IDENTITY()

	INSERT INTO PickListValues (PickListMasterID,PickListValue,PickListLabel)
		SELECT @PickID,'Test Acc1' ,'Test Acc1' 
			FROM PickListMaster
				WHERE PickListName='AccountCategory'

	INSERT INTO PickListValues (PickListMasterID,PickListValue,PickListLabel)
		SELECT @PickID,'Test Acc2','Test Acc2'  
			FROM PickListMaster
				WHERE PickListName='AccountCategory'
				
ROLLBACK TRAN



