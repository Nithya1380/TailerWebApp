GO
/****** Object:  StoredProcedure [dbo].[GetMeasurementField]    Script Date: 25-Dec-2018 20:33:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[GetMeasurementField]
	@CompanyID INT,
	@user INT
AS
-- =============================================
-- Author: Mahesh
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		MeasurementFieldID,
		FieldName,
		isRrepeat,
		OrderBy,
		ItemGroup ValItemGroup,
		Lang
	FROM MeasurementFieldMaster WITH(NOLOCK) WHERE CompanyID = @CompanyID AND ISNULL(isDeleted,0) = 0
		ORDER BY OrderBy

END
