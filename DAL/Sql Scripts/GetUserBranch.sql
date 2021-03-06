GO
/****** Object:  StoredProcedure [dbo].[GetUserBranch]    Script Date: 27-Nov-2018 22:46:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[GetUserBranch] 
	@Company INT,
	@user INT,
	@UserID INT,
	@EncludAllBranch BIT
	
AS
-- =============================================
-- Author: Mahesh
-- Create date: 8th OCt 2018
-- Description:	Get User branch list
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @UserBranchList VARCHAR(5000)

    IF ISNULL(@EncludAllBranch, 0)=1
	BEGIN
		SET @UserBranchList = 
		(
			SELECT BranchDetails.BranchID as id, BranchDetails.BranchName as name,COnVERT(BIT,CASE WHEN ISNULL(UserBranch.BranchID,0)!=0 THEN 1 ELSE 0 END) as Checked 
				FROM BranchDetails WITH(NOLOCK)
					LEFT OUTER JOIN UserBranch WITH(NOLOCK) ON UserBranch.BranchID = BranchDetails.BranchID 
							AND UserBranch.CompanyID = @Company AND UserBranch.UserID = @UserID AND ISNULL(UserBranch.isDeleted,0) = 0
				WHERE BranchDetails.CompanyID =  @Company AND ISNULL(BranchDetails.isDeleted ,0)= 0
			 FOR JSON PATH
		)

	END
	ELSE
	BEGIN
		SET @UserBranchList = 
		(
			SELECT BranchDetails.BranchID as id, BranchDetails.BranchName as name,COnVERT(BIT,CASE WHEN ISNULL(UserBranch.BranchID,0)!=0 THEN 1 ELSE 0 END) as Checked 
				FROM BranchDetails WITH(NOLOCK)
					INNER JOIN UserBranch WITH(NOLOCK) ON UserBranch.BranchID = BranchDetails.BranchID 
							AND UserBranch.CompanyID = @Company AND UserBranch.UserID = @UserID AND ISNULL(UserBranch.isDeleted,0) = 0
				WHERE BranchDetails.CompanyID =  @Company AND ISNULL(BranchDetails.isDeleted ,0)= 0
			  FOR JSON PATH
		)
	END 

	SELECT @UserBranchList AS UserBranchList

RETURN 0
END
