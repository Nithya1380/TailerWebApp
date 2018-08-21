ALTER PROCEDURE [dbo].[_U_ValidateLogin]
(
	@LoginId  varchar(100),
	@Password varchar(30),
	@EncryptedPassword varbinary(250),
	@IpAddesss varchar(50),
	@BrowserInfo varchar(800),
	@server varchar(50),
	@webSessionID varchar(50),
	@instanceName varchar(50) = '',
	@OperatingSystem  varchar(100)='',
	@Browser varchar(100)='',
	@BrowserVersion varchar(100)='',
	@SSOAuthToken VARCHAR(100)=''
)
AS

BEGIN
   IF NOT EXISTS(SELECT 1 FROM Users WITH(nolock),CompanyMaster WITH(nolock) 
                   WHERE Users.CompanyID=CompanyMaster.CompanyID
				    AND ISNULL(CompanyMaster.IsDeleted,0)=0
				    AND LoginID=LTRIM(RTRIM(@LoginId)) AND ([Password]=@EncryptedPassword OR ISNULL(@SSOAuthToken,'')<>''))
   BEGIN
	  INSERT INTO _H_Login(LoginID,IPAddress,LoginTime,LoginStatus,UserSessionID,ServerName,LoginType,UserSystemInfo, instanceName, 
		                   OperatingSystem, Browser,BrowserVersion,LoginSuccess,SSOAuthKey,FailedPassword)
		  VALUES(@LoginId,@IpAddesss,GETDATE(),0,@webSessionID,@server,1,@BrowserInfo,@instanceName,@OperatingSystem, @Browser,@BrowserVersion,0,
		         @SSOAuthToken,@Password)

	  RETURN -1
   END

	DECLARE @CompanyID INT,
	        @userId INT,
			@RoleID INT,
			@scope VARCHAR(max)

   SELECT @CompanyID =Users.CompanyID,
		  @userId=Users.UserID,
		  @RoleID = Users.RoleID
	   FROM Users with(nolock)
		  WHERE LTRIM(rtrim(LoginID))=LTRIM(rtrim(@LoginId ))								
			AND Users.[Status]='Active'
			

     IF(ISNULL(@RoleID,0) > 0 )
	 BEGIN
		SELECT @scope = ','+ (
						SELECT CONVERT(varchar,CompanyPermissions.PermissionIndexID)+',' 
							FROM RoleScope WITH(NOLOCK)
							     INNER JOIN CompanyPermissions WITH(nolock) ON RoleScope.CompanyPermissionID=CompanyPermissions.CompanyPermissionID
								WHERE RoleScope.RoleID = @RoleID
									AND RoleScope.CompanyID = @CompanyID
									  FOR XML PATH('') 
							)
	 END	

	  INSERT INTO _H_Login(LoginID,IPAddress,LoginTime,LoginStatus,UserSessionID,ServerName,LoginType,UserSystemInfo, instanceName,OperatingSystem, 
	               Browser,BrowserVersion,LoginSuccess,SSOAuthKey,CompanyID,UserID)
		  VALUES(@LoginId,@IpAddesss,GETDATE(),1,@webSessionID,@server,1,@BrowserInfo,@instanceName,@OperatingSystem, @Browser,@BrowserVersion,0,
		         @SSOAuthToken,@CompanyID,@userId)

	 SELECT Users.LoginID,
	        Users.RoleID,
			Users.CompanyID,
			'Active' AS LOGIN_STATUS,
			@scope AS Scope,
			Users.UserID,
			HomePages.HomePageURL AS LANDING_PAGE,
			Roles.RoleName,
			Users.isPasswordRegenerated,
			Users.PassowordExpireOn,
			180 AS SessionTimeOut,
			1 AS ROLE_TYPE,   --Admin Or Tailer Need to return
			Users.LoginID AS userName, --UserName,
			0 AS IsSSOLogin,
			@webSessionID AS UserSessionID,
			1 AS enableAutoSessionOut
	   FROM Users WITH(nolock)
	        INNER JOIN Roles WITH(nolock) ON Users.RoleID=Roles.RoleID
			INNER JOIN HomePages WITH(nolock) ON Roles.HomePage=HomePages.HomePageID
	     WHERE Users.CompanyID=@CompanyID
		   AND Users.UserID=@userId
		   AND Roles.CompanyID=@CompanyID

	RETURN 1
END