
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_C_GetCompanyAndBranchList]
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

    -- Insert statements for procedure here
	SELECT CONVERT(VARCHAR(MAX),(SELECT CompanyID,
					CompanyName,
					CompanyCode,
					CONVERT(VARCHAR,CompCreatedDate,101) as CompCreatedDate,
					(SELECT BranchDetails.CompanyID, BranchDetails.BranchID, BranchDetails.BranchCode, BranchDetails.BranchName, CONVERT(VARCHAR,BranchDetails.BranchCreatedDate,101) AS BranchCreatedDate
						FROM BranchDetails WITH(NOLOCK) WHERE ISNULL(BranchDetails.isDeleted,0) = 0
						AND BranchDetails.CompanyID = CompanyMaster.CompanyID FOR JSON PATH) as BranchList
				FROM CompanyMaster WITH(NOLOCK) WHERE ISNULL(IsDeleted,0) = 0
			FOR JSON PATH)) as CompanyList
END
GO
