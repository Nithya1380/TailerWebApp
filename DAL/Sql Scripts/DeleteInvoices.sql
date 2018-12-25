CREATE PROCEDURE DeleteInvoices
(
   @companyID INT,
   @BranchID INT,
   @UserID INT,
   @InvoiceIds VARCHAR(1000)
)

AS

BEGIN 
   IF(ISNULL(@companyID,0)=0 OR ISNULL(@InvoiceIds,'')='')
	  RETURN -1

	BEGIN TRY
		BEGIN TRAN
		   UPDATE InvoiceDetails SET isDeleted=1,
		                             DeletedOn=GETDATE(),
									 DeletedBy=@UserID
			 WHERE CompanyID=@companyID
			   AND InvoiceID IN(SELECT value FROM string_split(@InvoiceIds,','))

			UPDATE Invoices SET isDeleted=1,
		                        DeletedOn=GETDATE(),
							    DeletedBy=@UserID
			 WHERE CompanyID=@companyID
			   AND InvoiceID IN(SELECT value FROM string_split(@InvoiceIds,','))
		COMMIT TRAN
	END TRY
	BEGIN CATCH
	   IF(@@TRANCOUNT>0)
		ROLLBACK TRAN

		RETURN -1
	END CATCH

	RETURN 1
END