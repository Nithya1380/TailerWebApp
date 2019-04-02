
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[_Get_AccountInvoiceList]
	-- Add the parameters for the stored procedure here
	@Company INT,
	@user INT,
	@AccountID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CustomerID INT, @Invoices VARCHAR(MAX)
	SELECT TOP 1 @CustomerID = CustomerMasterID FROM AccountsMaster WITH(NOLOCK) WHERE CompanyID = @Company AND AccountMasterID = @AccountID

	SET @Invoices = (
	   SELECt InvoiceID, 
			BillNumber, 
			CONVERT(VARCHAR, DeliveryTime, 103) as DeliveryTime, 
			CONVERT(VARCHAR, TrailTime, 103) as TrailTime, 
			CONVERT(VARCHAR, InvoiceDate, 103) as InvoiceDate, 
			DesignerID, 
			MasterID, 
			SalesRepID 
		FROM Invoices WITH(NOLOCK) 
			WHERE Invoices.CompanyID = @Company AND Invoices.CustomerID = @CustomerID AND ISNULL(isDeleted,0)=0
				ORDER BY CreatedOn DESC
			FOR JSON PATH
		)

   SELEct @Invoices as Invoices

RETURN 0
		
END
GO
