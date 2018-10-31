
/****** Object:  StoredProcedure [dbo].[SaveCustomerDetails]    Script Date: 31-10-2018 23:25:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CreateNewInvoice]
(
   @companyID INT,
   @CustomerBranchID INT,
   @UserID INT,
   @customerInvoiceObj VARCHAR(1000),
   @customerInvoiceList VARCHAR(6000),
   @BillNumber VARCHAR(100) OUTPUT
)

AS

BEGIN
	IF NOT EXISTS(SELECT 1 FROM CompanyMaster WITH(nolock) WHERE CompanyID=@companyID)
	RETURN -1

	IF EXISTS(SELECT 1 FROM OPENJSON(@customerInvoiceObj) 
               WITH(
					 CustomerID INT '$.CustomerID' ,
					 MasterID INT '$.MasterID' ,
					 DesignerID INT '$.DesignerID' ,  
					 MobileNumber   VARCHAR(100) '$.MobileNumber'
				   )
				 WHERE ISNULL(MobileNumber,'')='' OR ISNULL(CustomerID,0)=0 OR ISNULL(MasterID,0)=0 OR ISNULL(DesignerID,0)=0)
	 RETURN -2

    IF EXISTS(SELECT ItemMasterID
		        FROM OPENJSON(@customerInvoiceList) 
				  WITH(
						ItemMasterID INT '$.ItemMasterID' 
					  )
				  WHERE ItemMasterID NOT IN (SELECT ItemmasterID FROM ItemMaster WITH(nolock) WHERE CompanyID=@companyID) 
			  )
		RETURN -3

	SET @BillNumber=''
	DECLARE @InvoiceID INT,
	        @LastInvoiceID INT,
			@BranchCode VARCHAR(5)

	SELECT @LastInvoiceID=MAX(InvoiceID) 
	  FROM Invoices WITH(nolock)
	    WHERE CompanyID=@companyID

	SELECT @BranchCode=BranchCode 
	  FROM BranchDetails WITH(nolock)
	    WHERE CompanyID=@companyID
		  AND BranchID=@CustomerBranchID

	SELECT @BillNumber=CASE ISNULL(@BranchCode,'') WHEN '' THEN @LastInvoiceID+1 ELSE ISNULL(@BranchCode,'')+CONVERT(VARCHAR(20),@LastInvoiceID+1) END

	BEGIN TRY
	  BEGIN TRAN _Tran_CreateInvoice
	     ;WITH Customer_InvoiceCTE AS
		 (
		   SELECT *
		     FROM OPENJSON(@customerInvoiceObj) 
				  WITH(
				        CustomerID INT '$.CustomerID' ,
						InvoiceSeries VARCHAR(100) '$.InvoiceSeries',
	                    MobileNumber VARCHAR(20) '$.MobileNumber',
	                    InvoiceDate VARCHAR(15) '$.InvoiceDate',
	                    TrailDate VARCHAR(15) '$.TrailDate',
	                    TrailTime VARCHAR(15) '$.TrailTime',
	                    SalesRepID INT '$.SalesRepID',
	                    MasterID INT '$.MasterID',
	                    DesignerID INT '$.DesignerID',
	                    DeliveryDate VARCHAR(15) '$.DeliveryDate',
	                    DeliveryTime VARCHAR(15) '$.DeliveryTime',
	                    PaymentNumber VARCHAR(100) '$.PaymentNumber',
	                    InvoiceLessCategory VARCHAR(100) '$.InvoiceLessCategory',
	                    LessRs VARCHAR(15) '$.LessRs',
	                    LessRsAmount VARCHAR(15) '$.LessRsAmount',
	                    Remarks VARCHAR(100) '$.Remarks',
	                    NetAmount VARCHAR(15) '$.NetAmount'
					  )
		 )

	     INSERT INTO Invoices(CompanyID,CustomerID,BillNumber,InvoiceSeries,MobileNumber,InvoiceDate,TrailDate,TrailTime,SalesRepID,
		                      MasterID,DesignerID,DeliveryDate,DeliveryTime,PaymentNumber,InvoiceLessCategory,LessRs,LessRsAmount,
							  Remarks,NetAmount,CreatedOn,CreatedBy)
		  SELECT @companyID,CustomerID,@BillNumber,InvoiceSeries,MobileNumber,InvoiceDate,TrailDate,TrailTime,SalesRepID,
		         MasterID,DesignerID,DeliveryDate,DeliveryTime,PaymentNumber,InvoiceLessCategory,LessRs,LessRsAmount,
				 Remarks,NetAmount,GETDATE(),@UserID 
		    FROM Customer_InvoiceCTE

		SET @InvoiceID=SCOPE_IDENTITY()

		;WITH Customer_InvoiceDetailsCTE AS
		 (
		   SELECT *
		     FROM OPENJSON(@customerInvoiceList) 
				  WITH(
				        ItemMasterID INT '$.ItemMasterID' ,
						ItemCode VARCHAR(50) '$.ItemCode',
	                    ItemDescription VARCHAR(200) '$.ItemDescription',
	                    ItemQuantity INT '$.ItemQuantity',
	                    ItemPrice VARCHAR(15) '$.ItemPrice',
	                    ItemDiscount VARCHAR(15) '$.ItemDiscount',
	                    GST VARCHAR(15) '$.GST',
	                    SGST VARCHAR(15) '$.SGST',
	                    AmountPending VARCHAR(15) '$.AmountPending'
					  )
		 )

		 INSERT INTO InvoiceDetails(CompanyID,InvoiceID,ItemMasterID,ItemCode,ItemDescription,ItemQuantity,ItemPrice,ItemDiscount,
		                            GST,SGST,AmountPending,CreatedOn,CreatedBy)
			  SELECT @companyID,@InvoiceID,ItemMasterID,ItemCode,ItemDescription,ItemQuantity,ItemPrice,ItemDiscount,
		             GST,SGST,AmountPending,GETDATE(),@UserID
				 FROM Customer_InvoiceDetailsCTE
				   WHERE ISNULL(ItemMasterID,0)<>''

	  COMMIT TRAN _Tran_CreateInvoice
	END TRY
	BEGIN CATCH
	   IF(@@TRANCOUNT>0)
	      ROLLBACK TRAN _Tran_CreateInvoice

	    RETURN -1
	END CATCH

	RETURN 1

				 
END