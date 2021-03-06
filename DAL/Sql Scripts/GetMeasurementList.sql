GO
/****** Object:  StoredProcedure [dbo].[GetMeasurementList]    Script Date: 28-Nov-2018 23:04:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetMeasurementList] 
	@Company INT,
	@User INT,
	@BranchId INT=0,
	@AccountCode VARCHAR(20)='',
	@AccountName VARCHAR(50)='',
	@DeliveryFrom VARCHAR(10)='',
	@DeliveryTo VARCHAR(10)=''
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

	DECLARE @MeasurementList VARCHAR(MAX),
			@Filter nvarchar(2000)='',
			@SqlExec nvarchar(4000) 

	IF ISNULL(@AccountCode,'')!=''
		SET @Filter +=' AND AccountsMaster.AccountCode = '+@AccountCode

	IF ISNULL(@AccountName,'')!=''
		SET @Filter +=' AND AccountsMaster.AccountName LIKE ''%'+@AccountName+'%'''

	IF ISNULL(@DeliveryFrom,'')!='' AND ISNULL(@DeliveryTo,'')!=''
		SET @Filter +=' AND MeasurementMaster.DeliDate BETWEEN CONVERT(DATE,'''+@DeliveryFrom+''',103) AND CONVERT(DATE,'''+@DeliveryFrom+''',103)'

	SET @SqlExec =	N'SET @MeasurementList = 
			(
				SELECT MeasurementMaster.MeasurementMasterID,
					MeasurementMaster.ItemDesc,
					CONVERT(VARCHAR,MeasurementMaster.MeasCreatedOn,103) as MeasCreatedOn,
					CONVERT(VARCHAR,MeasurementMaster.TrialDate,103) as TrialDate,
					CONVERT(VARCHAR,MeasurementMaster.DeliDate,103) as DeliDate,
					AccountsMaster.AccountName
				FROM MeasurementMaster WITH(NOLOCK), AccountsMaster WITH(NOLOCK) 
					WHERE MeasurementMaster.CompanyID = '+CONVERT(VARCHAR,@Company)+'
						AND AccountsMaster.CompanyID = '+CONVERT(VARCHAR,@Company)+'
						AND AccountsMaster.AccountMasterID = MeasurementMaster.AccountID
						'+@Filter+'
				 ORDER BY AccountsMaster.AccountName, MeasurementMaster.DeliDate, MeasurementMaster.MeasCreatedOn
					FOR JSON PATH
			)'

	EXECUTE sp_executesql @SqlExec, N'@MeasurementList VARCHAR(MAX) OUTPUT', @MeasurementList = @MeasurementList OUTPUT
		

	SELECT @MeasurementList MeasurementList

 RETURN 0
END
