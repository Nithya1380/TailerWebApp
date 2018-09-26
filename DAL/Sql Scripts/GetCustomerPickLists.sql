ALTER PROCEDURE DBO.GetCustomerPickLists
(
	@companyID INT,
	@CustomerID INT,
	@UserID INT
)
AS

BEGIN
		EXEC GetPickLists @companyID,'AccountCategory'

		EXEC GetPickLists @companyID,'AccountDateCategory'

		EXEC GetPickLists @companyID,'AccountParentType'

		EXEC GetPickLists @companyID,'AccountReverse'

		EXEC GetPickLists @companyID,'AccountSch6Group'

		EXEC GetPickLists @companyID,'AccountTDSCategory'

		EXEC GetPickLists @companyID,'AccountTDSDefault'

		EXEC GetPickLists @companyID,'AccountType'

		EXEC GetPickLists @companyID,'City'

		EXEC GetPickLists @companyID,'Country'

		EXEC GetPickLists @companyID,'State'

		EXEC GetPickLists @companyID,'SRNames'

		EXEC GetPickLists @companyID,'SupplierCategories'

		EXEC GetPickLists @companyID,'SupplierTypes'

		RETURN 1

		
END