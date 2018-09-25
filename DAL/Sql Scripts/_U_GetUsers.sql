SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Alter PROCEDURE _U_GetUsers
	@Company INT,
	@user INT
AS
-- =============================================
-- Author: Mahesh
-- Create date: 23th Sep 2018
-- Description:	get users list
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UserID, UserName, LoginID, Users.RoleID, Roles.RoleName FROM Users WITH(NOLOCK), Roles WITH(NOLOCK)
		WHERE ISNULL(Users.isDeleted,0) = 0 AND Users.CompanyID = @Company
			AND Roles.CompanyID = @Company AND Roles.RoleID = Users.RoleID
	FOR JSON PATH
END
GO

