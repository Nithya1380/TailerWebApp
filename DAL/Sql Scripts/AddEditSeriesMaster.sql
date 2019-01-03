SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[AddEditSeriesMaster]
	@Company INT,
	@user INT,
	@Branch INT,
	@SeriesMasterID INT,
	@SeriesMaster VARCHAR(2000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
	DEclare @Audit VARCHAR(500)=''

BEGIN TRAN
	IF ISNULL(@SeriesMasterID,0) = 0
	BEGIN
		INSERT INTO SeriesMaster(
			CompanyID,
			BranchID,
			CreatedBy,
			StartDate,
			Prefix,
			LastValue,
			WithZero,
			Width
		)	
		SELECT @Company,
			   @Branch,
			   @user,
			   CONVERT(DATE,StartDate,103),
			   Prefix,
			   LastValue,
			   WithZero,
			   Width
			FROM OPENJSON(@SeriesMaster) WITH(
				StartDate VARCHAR(10),
				Prefix VARCHAR(50),
				LastValue INT,
				WithZero BIT,
				Width INT
			)	

		SET @SeriesMasterID = SCOPE_IDENTITY()

		INSERT INTO AuditLogs(
			CompanyID,
			BranchID,
			CreatedBy,
			ActivityType,
			ActivitID,
			LogDescription
		)

		SELECT @Company,
		   @Branch,
		   @user,
		   'SeriesMasterID',
		   @SeriesMasterID,
		   'New series creteded with start date '''+StartDate+''', '+
		   IIF(ISNULL(Prefix,'')!='','Prefix '''+Prefix+''', ','')+
		   IIF(ISNULL(LastValue,0)!=0,'Last Value '''+CONVERT(VARCHAR,LastValue)+''', ','')+
		   IIF(ISNULL(WithZero,0)=0,'with zero no, ','with zero yes, ')+
		   IIF(ISNULL(Width,0)!=0,'width '''+CONVERT(VARCHAR,Width)+''', ','')
		FROM OPENJSON(@SeriesMaster) WITH(
			StartDate VARCHAR(10),
			Prefix VARCHAR(50),
			LastValue INT,
			WithZero BIT,
			Width INT
		)

	END
	ELSE
	BEGIN
		
		SELECT
		 @Audit = 
		   IIF(CONVERT(DATE,SeriesMaster.StartDate)!=CONVERT(DATE,temp.StartDate,103),' start date from '''+CONVERT(VARCHAR,SeriesMaster.StartDate,103)+''' to '''+temp.StartDate+''', ','')+
		   IIF(ISNULL(SeriesMaster.LastValue,0)!=ISNULL(temp.LastValue,0),'Last Value from'''+CONVERT(VARCHAR,SeriesMaster.LastValue)+''' to '''+CONVERT(VARCHAR,temp.LastValue)+''', ','')+
		   IIF(ISNULL(SeriesMaster.WithZero,0)!=ISNULL(temp.WithZero,0),IIF(ISNULL(temp.WithZero,0)=0,'with zero from ''yes'' to ''no'', ','with zero from ''no'' to ''yes'', '),'')+
		   IIF(ISNULL(SeriesMaster.Width,0)!=ISNULL(temp.Width,0),'width from'''+CONVERT(VARCHAR,SeriesMaster.Width)+''' to '''+CONVERT(VARCHAR,temp.Width)+'''','')
		FROM SeriesMaster WITH(NOLOCK),
				OPENJSON(@SeriesMaster) WITH(
				StartDate VARCHAR(10),
				Prefix VARCHAR(50),
				LastValue INT,
				WithZero BIT,
				Width INT
			)temp
		WHERE SeriesMaster.SeriesMasterID = @SeriesMasterID
			AND SeriesMaster.CompanyID = @Company

		UPDATE SeriesMaster
			SET StartDate = CONVERT(DATE,temp.StartDate,103),
			Prefix = temp.Prefix,
			LastValue = temp.LastValue,
			WithZero = temp.WithZero,
			Width = temp.Width
		FROM OPENJSON(@SeriesMaster) WITH(
			StartDate VARCHAR(10),
			Prefix VARCHAR(50),
			LastValue INT,
			WithZero BIT,
			Width INT
		) temp
		WHERE SeriesMaster.SeriesMasterID = @SeriesMasterID
			AND SeriesMaster.CompanyID = @Company

		IF ISNULL(@Audit,'')!=''
		BEGIN
				INSERT INTO AuditLogs(
					CompanyID,
					BranchID,
					CreatedBy,
					ActivityType,
					ActivitID,
					LogDescription
				)

				SELECT @Company,
				   @Branch,
				   @user,
				   'SeriesMasterID',
				   @SeriesMasterID,
				   'Series start date '''+CONVERT(VARCHAR,SeriesMaster.StartDate,103)+''' has modifyed '+@Audit
				  FROM SeriesMaster WITH(NOLOCK)
					WHERE SeriesMaster.SeriesMasterID = @SeriesMasterID
						AND SeriesMaster.CompanyID = @Company
			END
	END

	SELECT @SeriesMasterID as SeriesMasterID

COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0
END
GO
