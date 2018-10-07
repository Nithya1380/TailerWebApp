BEGIN TRAN
   INSERT INTO HomePages(HomePageName,HomePageURL)
   SELECT 'Admin Home Page','UI/Admin/AdminHome.aspx' UNION
   SELECT 'Tailer Home Page','UI/Tailer/TailerHome.aspx'
ROLLBACK TRAN

select *from HomePages

--Create Company
BEGIN TRAN
   INSERT INTO CompanyMaster(CompanyName,CompanyCode,AddressID,CreatedBy,CreatedOn)
   SELECT 'Test Company','TC',NULL,NULL,GETDATE()
ROLLBACK TRAN

--Create Role
BEGIN TRAN
   INSERT INTO Roles(CompanyID,RoleName,HomePage)
   SELECT 3,'Tailer Role Admin',6
ROLLBACK TRAN
select *from Roles
--Create USers
BEGIN TRAN
   INSERT INTO users(CompanyID,LoginID,[password],RoleID,[Status])
   SELECT 3,'Matt.mach@gmail.com',0x70774F6D7868467A4F6A6F3D,1003,'Active'
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

BEGIN TRAN
   DECLARE @PickListID INT
   INSERT INTO PickListMaster(PickListName) VALUES('ItemMasterGroup')

   SELECT @PickListID=SCOPE_IDENTITY()
   INSERT INTO PickListValues(PickListMasterID,PickListLabel,PickListValue)
   VALUES(@PickListID,'Shirts','Shirts'),(@PickListID,'Pants','Pants')

ROLLBACK TRAN


