
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DeleteMeasurementField] 
	@CompanyID INT,
	@user INT,
	@MeasurementFieldID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
	BEGIN TRAN
		UPDATE MeasurementFieldMaster SET isDeleted = 1, DeletedBy = @user, DeletedOn = GETDATE() 
			WHERE CompanyID = @CompanyID  AND MeasurementFieldID = @MeasurementFieldID
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0
END
GO
