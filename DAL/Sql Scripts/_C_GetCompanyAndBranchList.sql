SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_C_GetCompanyAndBranchList]
	@CompanyID INT,
	@User INT
AS
-- =============================================
-- Author:	 Mahesh
-- Create date: 08th Sep 2018
-- Description:	Get Company And Branch List
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CompanyList VARCHAR(MAX),
			@BranchList VARCHAR(MAX)
    -- Insert statements for procedure here

	IF ISNULL(@CompanyID,0) = 0
	BEGIN
		SET @CompanyList = 
		(
			SELECT	CompanyID,
					CompanyName,
					CompanyCode,
					CONVERT(VARCHAR,CompCreatedDate,101) as CompCreatedDate
					FROM CompanyMaster WITH(NOLOCK) WHERE ISNULL(IsDeleted,0) = 0
					ORDER BY CompanyMaster.CompanyName
				FOR JSON PATH
			)

		SET @BranchList = 
		(SELECT BranchDetails.CompanyID, 
				BranchDetails.BranchID, 
				BranchDetails.BranchCode, 
				BranchDetails.BranchName, 
				CONVERT(VARCHAR,BranchDetails.BranchCreatedDate,101) AS BranchCreatedDate,
				CompanyMaster.CompanyName
			FROM BranchDetails WITH(NOLOCK), CompanyMaster WITH(NOLOCK) 
				WHERE ISNULL(BranchDetails.isDeleted,0) = 0 AND ISNULL(CompanyMaster.IsDeleted,0) = 0
					AND BranchDetails.CompanyID = CompanyMaster.CompanyID
				ORDER BY CompanyMaster.CompanyName, BranchDetails.BranchName
			FOR JSON PATH
		)
	END
	ELSE
	BEGIN
		SET @CompanyList = 
		(
			SELECT CompanyID,
						CompanyName,
						CompanyCode,
						CONVERT(VARCHAR,CompCreatedDate,101) as CompCreatedDate
					FROM CompanyMaster WITH(NOLOCK) WHERE ISNULL(IsDeleted,0) = 0 AND CompanyID = @CompanyID
					ORDER BY CompanyMaster.CompanyName
				FOR JSON PATH
			)

		SET @BranchList = 
		(SELECT BranchDetails.CompanyID, 
				BranchDetails.BranchID, 
				BranchDetails.BranchCode, 
				BranchDetails.BranchName, 
				CONVERT(VARCHAR,BranchDetails.BranchCreatedDate,101) AS BranchCreatedDate
			FROM BranchDetails WITH(NOLOCK) WHERE ISNULL(BranchDetails.isDeleted,0) = 0 AND CompanyID = @CompanyID
			ORDER BY BranchDetails.BranchName
			FOR JSON PATH
		)
	END
	SELECT @CompanyList as CompanyList, @BranchList as BranchList
END
GO
