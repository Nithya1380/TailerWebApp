SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPincodeDetails]
	@CompanyID INT,
	@User INT,
	@Pincode INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT TOP 1 
		Pincode,
		UPPER(districtname) as districtname,
		UPPER(statename) as statename
   FROM PincodeDirectory WITH(NOLOCK) WHERE Pincode = @Pincode FOR JSON PATH
END
GO
