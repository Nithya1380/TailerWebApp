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



