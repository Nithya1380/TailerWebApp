GO
/****** Object:  StoredProcedure [dbo].[SaveMeasurementField]    Script Date: 25-Dec-2018 20:23:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SaveMeasurementField] 
	@CompanyID INT,
	@user INT,
	@MeasurementField tempMeasurField readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
	BEGIN TRAN
		MERGE MeasurementFieldMaster AS TARGET
		USING (
				SELECT MeasurementFieldID, FieldName, isRrepeat, OrderBy, ItemGroup, Lang FROM @MeasurementField  
					) AS SOURCE 
		ON (TARGET.MeasurementFieldID = SOURCE.MeasurementFieldID AND TARGET.CompanyID = @CompanyID)
		WHEN MATCHED THEN
			UPDATE SET TARGET.FieldName = SOURCE.FieldName, 
					   TARGET.isRrepeat = SOURCE.isRrepeat,
					   TARGET.OrderBy = SOURCE.OrderBy,
					   TARGET.ItemGroup = SOURCE.ItemGroup,
					   TARGET.Lang = SOURCE.Lang
		WHEN NOT MATCHED BY TARGET THEN 
		 INSERT (FieldName, isRrepeat, OrderBy, ItemGroup, CompanyID, Lang, CreatedBy) 
		 VALUES (SOURCE.FieldName, SOURCE.isRrepeat, SOURCE.OrderBy, SOURCE.ItemGroup, @CompanyID, SOURCE.Lang, @user);
		--WHEN NOT MATCHED BY SOURCE THEN 
		--DELETE;

	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0
END
