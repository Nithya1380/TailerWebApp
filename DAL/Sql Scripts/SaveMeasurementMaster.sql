GO
/****** Object:  StoredProcedure [dbo].[SaveMeasurementMaster]    Script Date: 28-Nov-2018 22:16:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SaveMeasurementMaster]
	@CompanyID INT,
	@user INT,
	@MeasurementMasterID INT,
	@Measurement VARCHAR(4000),
	@MeasurementField VARCHAR(8000)
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
BEGIN TRY
BEGIN TRAN
    IF ISNULL(@MeasurementMasterID,0) = 0
	BEGIN
		INSERT INTO MeasurementMaster(
			CompanyID,
			AccountID,
			MeasuNo,
			CreatedBy,
			MeasCreatedOn,
			ItemID,
			ItemDesc,
			BodyFit,
			Remark,
			TrialDate,
			DeliDate,
			MeasDate,
			Qty,
			MeasWeight,
			InvoiceID,
			SalesRep,
			Designer,
			MasterID,
			BillNo
		)
		SELECT 
			@CompanyID,
			AccountID,
			MeasuNo,
			@user,
			CONVERT(DATE,NULLIF(MeasCreatedOn,''),103),
			ItemID,
			ItemDesc,
			BodyFit,
			Remark,
			CONVERT(DATE,NULLIF(TrialDate,''),103),
			CONVERT(DATE,NULLIF(DeliDate,''),103),
			CONVERT(DATE,NULLIF(MeasDate,''),103),
			Qty,
			MeasWeight,
			NULLIF(InvoiceID,0),
			SalesRep,
			Designer,
			MasterID,
			BillNo
		FROM OPENJSON(@Measurement)  
			WITH (
				AccountID INT,
				MeasuNo VARCHAR(20),
				MeasCreatedOn VARCHAR(10),
				ItemID INT,
				ItemDesc VARCHAR(30),
				BodyFit VARCHAR(20),
				Remark VARCHAR(50),
				TrialDate VARCHAR(10),
				DeliDate VARCHAR(10),
				MeasDate VARCHAR(10),
				Qty INT,
				MeasWeight FLOAT,
				InvoiceID INT '$.Invoice.InvoiceID',
				SalesRep INT '$.SalesRep.EmployeeMasterID',
				Designer INT '$.Designer.EmployeeMasterID',
				MasterID INT '$.Master.EmployeeMasterID',
				BillNo VARCHAR(100) '$.Invoice.BillNumber'
			) tempMeas

		 SET @MeasurementMasterID = SCOPE_IDENTITY()

		 INSERT INTO MeasurementFieldDetail(
				MeasurementFieldID, 
				MeasurementMasterID,
				FieldValue,
				CompanyID,
				CreatedBy)
		SELECT id,
			   @MeasurementMasterID,
			   FValue,
			   @CompanyID,
			   @user
			FROM OPENJSON(@MeasurementField)  
			WITH (
				id INT,
				FValue VARCHAR(500)
			) tempMeas


	END
	ELSE
	BEGIN
		UPDATE MeasurementMaster
			SET AccountID = tempMeas.AccountID,
				MeasuNo = tempMeas.MeasuNo,
				MeasCreatedOn = CONVERT(DATE,NULLIF(tempMeas.MeasCreatedOn,''),103),
				ItemID = tempMeas.ItemID,
				ItemDesc = tempMeas.ItemDesc,
				BodyFit = tempMeas.BodyFit,
				Remark = tempMeas.Remark,
				TrialDate = CONVERT(DATE,NULLIF(tempMeas.TrialDate,''),103),
				DeliDate = CONVERT(DATE,NULLIF(tempMeas.DeliDate,''),103),
				MeasDate = CONVERT(DATE,NULLIF(tempMeas.MeasDate,''),103),
				Qty = tempMeas.Qty,
				MeasWeight = NULLIF(tempMeas.MeasWeight,0),
				InvoiceID = tempMeas.InvoiceID,
				SalesRep = tempMeas.SalesRep,
				Designer = tempMeas.Designer,
				MasterID = tempMeas.MasterID,
				BillNo = tempMeas.BillNo
		FROM OPENJSON(@Measurement)  
			WITH (
				AccountID INT,
				MeasuNo VARCHAR(20),
				MeasCreatedOn VARCHAR(10),
				ItemID INT,
				ItemDesc VARCHAR(30),
				BodyFit VARCHAR(20),
				Remark VARCHAR(50),
				TrialDate VARCHAR(10),
				DeliDate VARCHAR(10),
				MeasDate VARCHAR(10),
				Qty INT,
				MeasWeight FLOAT,
				InvoiceID INT '$.Invoice.InvoiceID',
				SalesRep INT '$.SalesRep.EmployeeMasterID',
				Designer INT '$.Designer.EmployeeMasterID',
				MasterID INT '$.Master.EmployeeMasterID',
				BillNo VARCHAR(100) '$.Invoice.BillNumber'
			) tempMeas 
		WHERE CompanyID = @CompanyID AND MeasurementMasterID = @MeasurementMasterID

		MERGE MeasurementFieldDetail AS TARGET
		USING (SELECT id, FValue FROM OPENJSON(@MeasurementField)  
					WITH (
						id INT,
						FValue VARCHAR(500)
					)) AS SOURCE
		ON (TARGET.MeasurementFieldID = SOURCE.id AND TARGET.MeasurementMasterID = @MeasurementMasterID AND TARGET.CompanyID = @CompanyID) 
		WHEN MATCHED AND TARGET.FieldValue <> SOURCE.FValue 
		THEN UPDATE SET TARGET.FieldValue = SOURCE.FValue
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT (MeasurementFieldID, MeasurementMasterID, FieldValue, CompanyID, CreatedBy) 
		VALUES (SOURCE.id, @MeasurementMasterID, SOURCE.FValue, @CompanyID, @user);

	END

	SELECT @MeasurementMasterID
COMMIT TRAN
END TRY
BEGIN CATCH
	
	ROLLBACK TRAN
	RETURN 1
END CATCH
RETURN 0
END
