using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlTypes;
using System.Collections;
using DAL.Utilities;

namespace DAL
{
    public class KanDB
    {

        private string m_connString = "";
        private bool m_bConnected = false;
        private SqlConnection conn = null;
        private SqlCommand SPCommand = null;
        private DateTime executionEndedOn = DateTime.Now;
        private DateTime executionStartedOn = DateTime.Now;
        private string spname;
        private int m_iErrorCode = 0;
        private string m_errorString = "";
        private SqlDataReader dr = null;
        public bool IsSqlExceptionOccured;
        private const int DB_CONNECTION_TIMEOUT = 2400;  // 15 minutes	session timeout is increased to 15 mins By Anumodh on 23 Dec 08
        ProcedureLog Proc = new ProcedureLog();
        private int m_USerID = 0;
        private int m_HHAID = 0;
        private int m_CgTaskId = 0;
        private string CurrentExecutingDataBase = string.Empty;
        /*
		 * Default constructor...No parameters..		 
		*/
        public KanDB()
        {
            ResetSQLException();
        }

        /*
		 * Constructor..Take connection string as parameter
		*/
        public KanDB(string connString)
        {
            ResetSQLException();
            m_connString = connString;
        }

        public KanDB(string connString, int hha, int user)
        {
            ResetSQLException();
            m_connString = connString;

        }

        /*
		 * Return Last Error Number
		 * */
        public int GetLastErrorCode()
        {
            return m_iErrorCode;
        }

        /*
		 * Return Last Error Description
		 * */
        public string GetLastError()
        {
            //Anish Added this functions on 01 Feb 2010 to Handle the SQL Exceptions.
            //To hide the Real SQL exceptions from End users.Instead showing a custom message.
            if (IsSqlExceptionOccured && m_errorString == "")
                m_errorString = "Failed to process request to get data from database";
            return m_errorString;
        }

        /*
		 * Function to connect to the database using the connectioin string set before..
		 * if there is no connection string, it return false
		 * if connection fails, return false..
		 * */
        public bool Connect()
        {
            if (m_bConnected) // Already connected..
                return true;

            if (m_connString == "") //No connect string specified
                throw new Exception("Empty Connect string..please specify a connect string");

            try
            {
                conn = new SqlConnection(m_connString);
                conn.Open();
                m_bConnected = true;
                executionStartedOn = DateTime.Now;
                this.CurrentExecutingDataBase = this.GetPrivateDBName(m_connString);
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return m_bConnected;
        }

        /*
		 * Function to connect to the database using the connectioin string parameter..
		 * if connection string is empty, it return false
		 * if connection fails, return false..
		 * */
        public bool Connect(string connString)
        {
            m_connString = connString;
            return Connect();
        }

     
      
        /*
		 * Function sets the connection string
		 * */
        public void SetConnString(string connString)
        {
            m_connString = connString;
        }

        /*
		 * Function to disconnect database connection, which will make the connection
		 * to return to connection pool
		 * It also releases any other resources..
		 * */
        /// <summary>
        ///  Modified 
        ///        By : Nithya
        ///        On : 04Th Dec 2014
        ///      Desc :Finally Closing Reader and Connection if Open
        /// </summary>
        public void Disconnect()
        {
            if (m_bConnected)
            {
                try
                {
                    //Check if stored procedure execution time should be logged or not
                    bool logProcedureTime = false; //read this from web.config
                    try
                    {
                        // if (Convert.ToInt16(System.Configuration.ConfigurationSettings.AppSettings.Get("StoredProcedureLog_Enable").ToString()) == 1)
                        if (System.Configuration.ConfigurationManager.AppSettings.Get("StoredProcedureLog_Enable") != null)
                            if (Convert.ToInt16(System.Configuration.ConfigurationManager.AppSettings.Get("StoredProcedureLog_Enable").ToString()) == 1)
                                logProcedureTime = true;
                    }
                    catch (Exception exe)
                    {
                        
                        Utils.Write(exe);
                    }

                    if (logProcedureTime)
                    {
                        executionEndedOn = DateTime.Now;
                        Proc._spname = SPCommand.CommandText;

                        TimeSpan diff = Convert.ToDateTime(executionEndedOn).Subtract(Convert.ToDateTime(executionStartedOn));
                     

                        Proc._timeDuration = diff;
                        Proc.userID = m_USerID;
                        Proc.HHA = m_HHAID;
                        Proc.SP_Params = m_CgTaskId.ToString();
                        Proc.StartedOn = executionStartedOn;
                        Proc.EndedOn = executionEndedOn;
                        Proc.DataBaseName = this.CurrentExecutingDataBase;
                        //if (SPCommand.CommandText != "AddProcedureLog")//do not log to procedure timing log when disconnecting from procedure log function
                        //    ProcedureTiming.AddLog(Proc);
                    }

                    //Close SqlDataReader
                    if (dr != null)
                    {
                        dr.Close();
                        dr = null;
                    }

                    //Close connection
                    conn.Close();
                    conn = null;
                    m_bConnected = false;
                }
                catch (SqlException e)
                {
                    m_errorString = e.Message;
                    m_iErrorCode = e.Number;
                    SetSqlException(e); ;
                    throw new Exception(e.Message);
                }
                catch (Exception e)
                {
                    m_errorString = e.Message;
                    throw new Exception(e.Message);
                }

                finally
                {
                    if (dr != null && !dr.IsClosed)
                        dr.Close();

                    if (conn != null && conn.State == ConnectionState.Open)
                        conn.Close();
                }
            }
        }

        /*
		 * Function which accepts an SQL query as parameter which won't return any result
		 * It returns the number of records updated
		 * when fails, return -2
		 * */
        public int ExecuteNonQuery(string query)
        {
            int iAffected;
            try
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                iAffected = cmd.ExecuteNonQuery();
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                iAffected = -2;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                iAffected = -2;
                throw new Exception(e.Message);
            }
            return iAffected;
        }

        /*
		 * Function which executes an SQL query which will return an integer value
		 * function returns the value returned from query.. -2 if any error
		 * */
        public int ExecuteCountQuery(string query)
        {
            int iCount;
            try
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                iCount = (int)cmd.ExecuteScalar();
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                iCount = -2;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                iCount = -2;
                throw new Exception(e.Message);
            }
            return iCount;
        }

        /*
		 * Function which executes an SQL query and return the no. of rows affected
		 * */
        public string ExecuteQuery(string query)
        {
            string cnt = "";

            try
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    cnt = dr.GetValue(0).ToString();
                }
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }
            return cnt;
        }


        /*
		 * Function which executes the SQL query and returns a dataset.
		 * Calling function has to close the dataset after use..
		 * */
        public SqlDataReader ExecuteSelectQuery(string query)
        {
            try
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                dr = cmd.ExecuteReader();
            }
            catch (SqlException e)
            {

                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                dr = null;

            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                dr = null;
                throw new Exception(e.Message);
            }
            return dr;
        }

        /*
		 * Function executes a stored procedure whose name is the parameter.
		 * It will take all parameters alredy set using the AddParam functions before..
		 * when call this function again, you have to clear parameters and set again..
		 * Returns number of records affected or -2 if failure..
		 * */
        public int ExecuteNonSP(string spName)
        {
            int iAffected;
            try
            {
                if (SPCommand == null)
                    SPCommand = new SqlCommand();

                SPCommand.Connection = conn;
                SPCommand.CommandType = CommandType.StoredProcedure;
                SPCommand.CommandText = spName;
                SPCommand.CommandTimeout = DB_CONNECTION_TIMEOUT;
                iAffected = SPCommand.ExecuteNonQuery();
                iAffected = 1;
            }
            catch (SqlException e)
            {
                Utils.Write(0, 0, "kandb.cs", spName, "", "", e);
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                iAffected = -2;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                iAffected = -2;
                throw new Exception(e.Message);
            }
            //ClearSPParams ();
            return iAffected;
        }

        /*
		 * Function executes a stored procedure whose name is the parameter, which return an integer value.
		 * It will take all parameters alredy set using the AddParam functions before..
		 * when call this function again, you have to clear parameters and set again..
		 * Returns number of records affected or -2 if failure..
		 * */
        public int ExecuteCountSP(string spName)
        {
            int iCount;
            try
            {
                if (SPCommand == null)
                    SPCommand = new SqlCommand();

                SPCommand.Connection = conn;
                SPCommand.CommandType = CommandType.StoredProcedure;
                SPCommand.CommandText = spName;
                SPCommand.CommandTimeout = DB_CONNECTION_TIMEOUT;
                iCount = (int)SPCommand.ExecuteScalar();
            }
            catch (SqlException e)
            {
                Utils.Write(0, 0, "kandb.cs", spName, "", "", e);
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                iCount = -2;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                iCount = -2;
                throw new Exception(e.Message);
            }
            return iCount;
        }

        /*
		 * Function executes a stored procedure whose name is the parameter, which return dataset.
		 * It will take all parameters alredy set using the AddParam functions before..
		 * when call this function again, you have to clear parameters and set again..
		 * Returns SqlDataReader..calling function has to close the Data Reader
		 * */
        public SqlDataReader ExecuteSelectSP(string spName)
        {
            try
            {
                if (SPCommand == null)
                    SPCommand = new SqlCommand();

                SPCommand.Connection = conn;
                SPCommand.CommandType = CommandType.StoredProcedure;
                SPCommand.CommandText = spName;
                SPCommand.CommandTimeout = DB_CONNECTION_TIMEOUT;
                dr = SPCommand.ExecuteReader();
            }
            catch (SqlException e)
            {
                Utils.Write(0, 0, "kandb.cs", spName, "", "", e);
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                dr = null;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                dr = null;
                throw new Exception(e.Message);
            }
            return dr;
        }

        //This SqlDataReader is for reading images from DB
        //Added on 28 March 2006
        //By Abhilash.P.R
        public SqlDataReader ExecuteSelectSP(string spName, bool IsSequentialAccess)
        {
            try
            {
                if (SPCommand == null)
                    SPCommand = new SqlCommand();

                SPCommand.Connection = conn;
                SPCommand.CommandType = CommandType.StoredProcedure;
                SPCommand.CommandText = spName;
                SPCommand.CommandTimeout = DB_CONNECTION_TIMEOUT;
                if (IsSequentialAccess == true)
                    dr = SPCommand.ExecuteReader(CommandBehavior.SequentialAccess);
                else
                    dr = this.ExecuteSelectSP(spName);
            }
            catch (SqlException e)
            {
                Utils.Write(0, 0, "kandb.cs", spName, "", "", e);
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                dr = null;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                dr = null;
                throw new Exception(e.Message);
            }
            return dr;
        }

        public string GetConnString()
        {
            return m_connString;
        }

        /*
		 * Function which clears the stored procedure parameters.
		 * */
        public void ClearSPParams()
        {

            try
            {
                ResetSQLException();
                if (SPCommand != null)
                    SPCommand.Parameters.Clear();
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

        }

        /*
		 * function to add  a new stored proecedure parameter to parameter collection
		 * Accepts all necessary parameters..
		 * return true if success..
		 * */
        public bool AddSPParam(string name, ParameterDirection direction,
            SqlDbType type, int size, object inValue)
        {
            bool retcode = false;
            try
            {
                SqlParameter param = new SqlParameter();
                param.ParameterName = name;
                param.Direction = direction;
                param.SqlDbType = type;
                param.Value = inValue;
                param.Size = size;
                param.IsNullable = true;

                if (SPCommand == null)
                    SPCommand = new SqlCommand();

                SPCommand.Parameters.Add(param);
                retcode = true;
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                Utils.Write("Exception in KanDB.cs - AddSPParam(). Message: " + e.Message);
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                Utils.Write("Exception in KanDB.cs - AddSPParam(). Message: " + e.Message);
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return retcode;
        }


        /*
     * function to add  a new stored proecedure Decimal-INPUT parameter to parameter collection
     * Accepts parameter name
     * return true if success..
     * */
        public bool AddSPDecimalParam(string name, decimal? iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Decimal, 0, iValue);
        }

        /*
		 * function to add  a new stored proecedure INTEGER-INPUT parameter to parameter collection
		 * Accepts parameter name and integer value
		 * return true if success..
		 * */
        public bool AddSPIntParam(string name, int? iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Int, 0, iValue);
        }


        public bool AddSPBigIntParam(string name, Int64? iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.BigInt, 0, iValue);
        }

        public bool AddSPStructParam(string name, object iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Structured, 0, iValue);
        }

        //Added By Syed on May 8th 2012 for datatables

        public bool AddSPStructuredParam(string name, DataTable iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Structured, 0, iValue);
        }

        public bool AddSPIntNULLParam(string name)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Int, 0, null);
        }

        public bool AddSPCharParam(string name, char cValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Char, 0, cValue);
        }

        public bool AddSPCharNULLParam(string name)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Char, 0, null);
        }

        /*
		 * function to add  a new stored proecedure INTEGER-INPUT parameter to parameter collection
		 * Accepts parameter name and integer value
		 * return true if success..
		 * */
        public bool AddSPTinyParam(string name, short iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.TinyInt, 0, iValue);
        }

        public bool AddSPTinyNullParam(string name)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.TinyInt, 0, null);
        }

        public bool AddSPTinyParamOut(string name)
        {
            return AddSPParam(name, ParameterDirection.Output, SqlDbType.TinyInt, 0, 0);
        }

        public bool AddSPSmallIntParam(string name, short iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.SmallInt, 0, iValue);
        }




        /*
		 * function to add  a new stored proecedure BIT-INPUT parameter to parameter collection
		 * Accepts parameter name and integer value
		 * return true if success..
		 * */
        public bool AddSPBoolParam(string name, bool iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Bit, 0, iValue);
        }

        public bool AddSPBoolNULLParam(string name)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Bit, 0, null);
        }

        // added by: SADIQ, On: 28-April-2014
        public bool AddSPBoolNULLParamNew(string name, bool? iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Bit, 0, iValue);
        }

        public bool AddSPMoneyParam(string name, SqlMoney iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Money, 0, iValue);
        }

        public bool AddSPSmallMoneyParam(string name, SqlMoney iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.SmallMoney, 0, iValue);
        }

        public bool AddSPBoolParamOut(string name)
        {
            return AddSPParam(name, ParameterDirection.Output, SqlDbType.Bit, 0, false);
        }

        /*
		 * function to add  a new stored proecedure FLOAT-INPUT parameter to parameter collection
		 * Accepts parameter name and float value
		 * return true if success..
		 * */
        /// <summary>
        /// Modified by: SADIQ,
        ///          On: 15-March-2014
        ///        Desc: made float as nullable
        /// </summary>
        /// <param name="name"></param>
        /// <param name="fValue"></param>
        /// <returns></returns>
        public bool AddSPFloatParam(string name, float? fValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Float, 0, fValue);
        }

        public bool AddSPFloatNULLParam(string name)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Float, 0, null);
        }

        /*
		 * function to add  a new stored proecedure DATE-INPUT parameter to parameter collection
		 * Accepts parameter name and string (date) value
		 * return true if success..
		 * */
        public bool AddSPDateParam(string name, string dateValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.DateTime, 0, dateValue);
        }


        /*
		 * function to add  a new stored proecedure STRING-INPUT parameter to parameter collection
		 * Accepts parameter name and string value
		 * return true if success..
		 * */
        public bool AddSPStringParam(string name, string stringValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.VarChar, 0, stringValue);
        }
        public bool AddSPImageParam(string name, byte[] pic)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Image, 0, pic);
        }
        public bool AddSPVarBinaryParam(string name, byte[] stringValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.VarBinary, 0, stringValue);
        }
        public bool AddSPTextParam(string name, string stringValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Text, 0, stringValue);
        }


        public bool AddSPStringNullParam(string name)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.VarChar, 0, null);
        }

        public bool AddSPStringParamInOut(string name, string stringValue)
        {
            return AddSPParam(name, ParameterDirection.InputOutput, SqlDbType.VarChar, 0, stringValue);
        }

        /*
            Created By: Devraj kumar
         *  On        : 31st May,2012 
         *  Desc      : This functoin will add table type input parameter to procedure
         */
        public bool AddSPDataTableParam(string name, object iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Structured, 0, iValue);
        }

        /*
		 * function to add  a new stored proecedure INTEGER-RETURN parameter to parameter collection
		 * Accepts parameter name
		 * return true if success..
		 * */
        public bool AddSPReturnIntParam(string name)
        {
            return AddSPParam(name, ParameterDirection.ReturnValue, SqlDbType.Int, 0, 0);
        }


        /*
		 * function to add  a new stored proecedure INTEGER-OUTPUT parameter to parameter collection
		 * Accepts parameter name
		 * return true if success..
		 * */
        public bool AddSPIntParamOut(string name)
        {
            return AddSPParam(name, ParameterDirection.Output, SqlDbType.Int, 0, 0);
        }

        public bool AddSPIntParamInOut(string name, int i)
        {
            return AddSPParam(name, ParameterDirection.InputOutput, SqlDbType.Int, 0, i);
        }


        /*
		 * function to add  a new stored proecedure FLOAT-OUTPUT parameter to parameter collection
		 * Accepts parameter name
		 * return true if success..
		 * */
        public bool AddSPFloatParamOut(string name)
        {
            return AddSPParam(name, ParameterDirection.Output, SqlDbType.Float, 0, 0);
        }


        /*
		 * function to add  a new stored proecedure DATE-OUTPUT parameter to parameter collection
		 * Accepts parameter name
		 * return true if success..
		 * */
        public bool AddSPDateParamOut(string name)
        {
            return AddSPParam(name, ParameterDirection.Output, SqlDbType.DateTime, 0, "");
        }


        /*
		 * function to add  a new stored proecedure STRING-OUTPUT parameter to parameter collection
		 * Accepts parameter name
		 * return true if success..
		 * */
        public bool AddSPStringParamOut(string name, int iSize)
        {
            return AddSPParam(name, ParameterDirection.Output, SqlDbType.VarChar, iSize, "");
        }

      
        public bool AddSPXmlParam(string name, string iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Xml, 0, iValue);
        }

        /// <summary>
        ///    Created
        ///         By : Chandrababu
        ///         On : 29Th July 2016
        ///       Desc : To Add Input/OutPut varBinary Parameter
        /// </summary>
        /// <param name="name"></param>
        /// <param name="stringValue"></param>
        /// <returns></returns>
        public bool AddSPVarBinaryInOutParam(string name, byte[] stringValue)
        {
            return AddSPParam(name, ParameterDirection.InputOutput, SqlDbType.VarBinary, 0, stringValue);
        }

        /*
		 * function which return the value of output parameters after stored procedure execution
		 * Accepts parameter name
		 * return value if success..empty if fails..
		 * */
        public object GetOutValue(string paramName)
        {
            object retValue = "";
            try
            {
                if (SPCommand != null)
                    retValue = SPCommand.Parameters[paramName].Value;
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return retValue;
        }


        /*
		 * function which return INTEGER value of output parameter after stored procedure execution
		 * Accepts parameter name
		 * return value if success..-2 if fails..
		 * */
        public int GetOutValueInt(string paramName)
        {
            int iRetValue = -2;
            try
            {
                if (SPCommand != null)
                    iRetValue = Convert.ToInt32(SPCommand.Parameters[paramName].Value);
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return iRetValue;
        }


        /*
		 * function which return FLOAT value of output parameter after stored procedure execution
		 * Accepts parameter name
		 * return value if success..-2 if fails..
		 * */
        public float GetOutValueFloat(string paramName)
        {
            float fRetValue = -2;
            try
            {
                if (SPCommand != null)
                    fRetValue = (float)Convert.ToDouble(SPCommand.Parameters[paramName].Value);
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return fRetValue;
        }

        public short GetOutValueTiny(string paramName)
        {
            short iRetValue = -2;
            try
            {
                if (SPCommand != null)
                    iRetValue = Convert.ToByte(SPCommand.Parameters[paramName].Value);
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return iRetValue;
        }


        public bool GetOutValueBool(string paramName)
        {
            bool iRetValue = false;
            try
            {
                if (SPCommand != null)
                    iRetValue = Convert.ToBoolean(SPCommand.Parameters[paramName].Value);
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return iRetValue;
        }



        /*
		 * function which return STRING value of output parameter after stored procedure execution
		 * Accepts parameter name
		 * return value if success..empty if fails..
		 * */
        public string GetOutValueString(string paramName)
        {
            string RetValue = "";
            try
            {
                if (SPCommand != null)
                    RetValue = SPCommand.Parameters[paramName].Value.ToString();
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return RetValue;
        }

        /*
		 * Function to clear Error Code and Error Description..
		 * */
        public void ClearErrors()
        {
            m_errorString = "";
            m_iErrorCode = 0;
        }
        public void SetError(int iError, string message)
        {
            m_errorString = message;
            m_iErrorCode = iError;
        }
        public void SetError(string message)
        {
            m_errorString = message;
        }

        public void SetError(int errorCode)
        {
            m_iErrorCode = errorCode;
        }
        /// <summary>
        /// Parse out the host name from an ODBC satabase connection string.
        /// TO DO is make this .NET-format conn string enabled
        /// </summary>
        /// <param name="strConn"></param>
        /// <returns></returns>
        public static string GetHostName(string strConn)
        {
            string ret = "unknown";
            try
            {
                if (null != strConn)
                {
                    int ind = -1;
                    if ((ind = strConn.IndexOf("data source")) >= 0 ||
                        (ind = strConn.IndexOf("Data source")) >= 0 ||
                        (ind = strConn.IndexOf("data Source")) >= 0 ||
                        (ind = strConn.IndexOf("Data Source")) >= 0)
                    {
                        ind = strConn.IndexOf("=", ind);
                        if (ind >= 0)
                        {
                            ++ind;
                            int end = -1;
                            if ((end = strConn.IndexOf(";", ind)) > 0)
                            {
                                return strConn.Substring(ind, end - ind).Trim();
                            }
                        }
                    }
                }
            }
            catch { }
            return ret;
        }

     
        public bool ExecuteSelectQueryWithRecords(string query, ref ArrayList arrList, ref ArrayList arrHeader)
        {
            bool ret = true;
            try
            {
                this.Connect();
                arrList = new ArrayList();

                SqlCommand cmd = new SqlCommand(query, conn);
                dr = cmd.ExecuteReader();
                int cnt = dr.FieldCount;
                for (int count = 0; count < cnt; count++)
                {
                    arrHeader.Add(dr.GetName(count));
                }
                string strData = "";
                string strEnd = ",";

                while (dr.Read())
                {
                    strData = "";

                    for (int count = 0; count < cnt; count++)
                    {
                        //arrList.Add(dr.GetValue(count));
                        if (count == cnt - 1)
                            strEnd = "\r\n";
                        else
                            strEnd = ",";
                        strData += dr.GetValue(count).ToString().Replace(",", " ") + strEnd;
                    }
                    arrList.Add(strData);
                }
                dr.Close();
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                dr = null;
                ret = false;
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                dr = null;
                ret = false;
                //throw new Exception (e.Message);
            }
            return ret;
        }

        //Anish Added this functions on 01 Feb 2010 to Handle the SQL Exceptions.
        //To hide the Real SQL exceptions from End users.Instead showing a custom message.
        private void ResetSQLException()
        {
            this.IsSqlExceptionOccured = false;
        }
        private void SetSqlException(SqlException e)
        {
            this.IsSqlExceptionOccured = true;
        }
        //Do not add any extra parameter to below structure as it is saving in Queue for logging
        public struct ProcedureLog
        {
            public int userID { get; set; }
            public string _spname;
            public TimeSpan _timeDuration { get; set; }
            public string Spname
            {
                get
                {
                    return _spname;
                }
                set
                {
                    _spname = value;
                }
            }
            public int HHA { get; set; }
            public string SP_Params { get; set; }
            public string InstanceName { get; set; }
            public DateTime StartedOn { get; set; }
            public DateTime EndedOn { get; set; }
            public string DataBaseName { get; set; }
        }

        /// <summary>
        /// To Connect to DB Whatever we want
        /// </summary>
        /// <param name="connString"></param>
        /// <returns></returns>
        public bool ConnectToParticluarDBAndServerBasedOnConnectionString(string connString)
        {

            m_connString = connString;

            if (m_connString == "") //No connect string specified
                throw new Exception("Empty Connect string..please specify a connect string");

            try
            {
                conn = new SqlConnection(m_connString);
                conn.Open();
                m_bConnected = true;
                executionStartedOn = DateTime.Now;
                this.CurrentExecutingDataBase = this.GetPrivateDBName(connString);
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return m_bConnected;
        }

        public bool ConnectToParticluarDBAndServer(string DataBaseName, string ServerName)
        {

            string connectionString = "";
            // get replacable conection string from web.config
            connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ZephyrLiveConnectionString"].ToString();

            // replace the connection string with Database and Server
            connectionString = connectionString.Replace("$DATABASE$", DataBaseName);
            connectionString = connectionString.Replace("$SERVER$", ServerName);

            m_connString = connectionString;

            if (m_connString == "") //No connect string specified
                throw new Exception("Empty Connect string..please specify a connect string");

            try
            {
                conn = new SqlConnection(m_connString);
                conn.Open();
                m_bConnected = true;
                executionStartedOn = DateTime.Now;
                this.CurrentExecutingDataBase = this.GetPrivateDBName(m_connString);
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return m_bConnected;
        }

    
        private string GetPrivateDBName(string connectionString)
        {
            string databaseName = string.Empty;
            try
            {
                if (conn != null && !string.IsNullOrEmpty(conn.Database))
                {
                    databaseName = conn.Database;
                }
                else if (!string.IsNullOrEmpty(connectionString))
                {
                    SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionString);
                    if (builder != null)
                        databaseName = builder.InitialCatalog;
                }
            }
            catch (Exception ex)
            {
                
                databaseName = string.Empty;
                Utils.Write(ex);
            }
            return databaseName;
        }



        public bool AddSPCharParamNULLNew(string name, char? iValue)
        {
            return AddSPParam(name, ParameterDirection.Input, SqlDbType.Char, 0, iValue);
        }


        public bool ConnectToMasterDB()
        {

            if (System.Configuration.ConfigurationManager.ConnectionStrings["ZephyrMaster"] == null)
                throw new Exception("Empty Connect string..please specify a connect string");

            m_connString = System.Configuration.ConfigurationManager.ConnectionStrings["ZephyrMaster"].ToString();

            if (m_connString == "") //No connect string specified
                throw new Exception("Empty Connect string..please specify a connect string");

            try
            {
                conn = new SqlConnection(m_connString);
                conn.Open();
                m_bConnected = true;
                executionStartedOn = DateTime.Now;
                this.CurrentExecutingDataBase = this.GetPrivateDBName(m_connString);
            }
            catch (SqlException e)
            {
                m_errorString = e.Message;
                m_iErrorCode = e.Number;
                SetSqlException(e); ;
                throw new Exception(e.Message);
            }
            catch (Exception e)
            {
                m_errorString = e.Message;
                throw new Exception(e.Message);
            }

            return m_bConnected;
        }

    }
}
