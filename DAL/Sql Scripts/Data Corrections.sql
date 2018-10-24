BEGIN TRAN
	   INSERT INTO HomePages(HomePageName,HomePageURL)
   SELECT 'Admin Home Page','UI/Admin/AdminHome.aspx' 
   UNION
   SELECT 'Tailer Home Page','UI/Tailer/TailerHome.aspx'
ROLLBACK TRAN

select *from HomePages

--Create Company
BEGIN TRAN
   INSERT INTO CompanyMaster(CompanyName,CompanyCode,AddressID,CreatedBy,CreatedOn)
   SELECT 'Test Company','TC',NULL,NULL,GETDATE()
ROLLBACK TRAN

SELECT *FROM CompanyMaster
--Create Role
BEGIN TRAN
   INSERT INTO Roles(CompanyID,RoleName,HomePage)
   SELECT 2,'Tailer Role Admin',3
ROLLBACK TRAN

select *from Roles
--Create USers
BEGIN TRAN
   INSERT INTO users(CompanyID,LoginID,[password],RoleID,[Status])
   SELECT 2,'Matt.mach@gmail.com',0x70774F6D7868467A4F6A6F3D,5,'Active'
ROLLBACK TRAN

--Create a Customer
BEGIN TRAN
  DECLARE @AddressID INT
  INSERT INTO Address(Address1,Address2,MobileNo,EmailID,HomePhoneNo,CompanyID)
  VALUES('391 County Rd 3386','391 Brooks, Jennifer Rd 3386','974256123','test@gmail.com','123456789',3)
  SET @AddressID=SCOPE_IDENTITY()

  INSERT INTO CustomerMaster(CustomerAddressID,CompanyID,Gender,FirstName,SurName)
  SELECT @AddressID,3,'Male','Test Name','Test Sur'
ROLLBACK TRAN


BEGIN TRAN
   DECLARE @PickListID INT
   INSERT INTO PickListMaster(PickListName) VALUES('AccountCategory')

   SELECT @PickListID=SCOPE_IDENTITY()
   INSERT INTO PickListValues(PickListMasterID,PickListLabel,PickListValue)
   VALUES(@PickListID,'Customer','Customer'),(@PickListID,'Supplier','Supplier')

ROLLBACK TRAN
GO
BEGIN TRAN
    DECLARE @PickID INT
	--Executed
	INSERT INTO PickListMaster(PickListName)
	SELECT 'EmployeePosition'

	select @PickID=SCOPE_IDENTITY()

	INSERT INTO PickListValues (PickListMasterID,PickListValue,PickListLabel)
	VALUES(@PickID, 'Biller', 'Biller'),
		  (@PickID, 'Admin', 'Admin'),
		  (@PickID, 'Master', 'Master'),
		  (@PickID, 'Designer', 'Designer'),
		  (@PickID, 'Owner', 'Owner')		
				
ROLLBACK

GO
BEGIN TRAN
   DELETE PickListValues
      FROM PickListMaster
      WHERE PickListValues.PickListMasterID=PickListMaster.PickListMasterID
	    AND PickListMaster.PickListName='ItemMasterGroup'

	DELETE FROM PickListMaster WHERE PickListName='ItemMasterGroup'

   DECLARE @PickListID INT
   INSERT INTO PickListMaster(PickListName) VALUES('ItemMasterGroup')

   SELECT @PickListID=SCOPE_IDENTITY()
   INSERT INTO PickListValues(PickListMasterID,PickListLabel,PickListValue)
   VALUES(@PickListID,'Top','Top'),(@PickListID,'Bottom','Bottom'),(@PickListID,'Mix','Mix')

ROLLBACK TRAN




