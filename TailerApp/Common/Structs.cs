using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TailerApp.Common
{
    public class Structs
    {
    }

    [Serializable]
    public class LoginUser
    {
        public string userName { get; set; }
        public string loginId { get; set; }
        public int failedAttempts { get; set; }
        public string userNode { get; set; }
        public int RoleID { get; set; }
        public string loginstatus { get; set; }
        public int CompanyID { get; set; }
        public string rolescope { get; set; }
        public string Landingpage { get; set; }
        public DateTime lastlogindate { get; set; }
        public string lastlogindateString { get; set; }
        public DateTime currentlogindate { get; set; }
        public int UserId { get; set; }
        public int UserType { get; set; }
        public int UserPrimaryKey { get; set; }
        public string RoleName { get; set; }
        public bool Is_Password_Regenerated { get; set; }

        public string mainMenuList { get; set; }
        public string subMenuList { get; set; }
        public string subSubMenuList { get; set; }
        public DateTime PASSWD_EXPIRY { get; set; }
        public string TimeZone { get; set; }
        public int roleType { get; set; }
        public int SessionOutTime { get; set; }
        public bool IsSSOLogin { get; set; }
        public string UserSessionID { get; set; }
        public bool enableAutoSessionOut { get; set; }

    }
}