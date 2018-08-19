using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace TailerApp.Common
{
    public static class Cryptography
    {
        public static string SECURITYKEY
        {
            get { return ("TailerApp"); }
        }
      
        public static string Encrypt(string dataToEncrypt)
        {
            if (dataToEncrypt != null && dataToEncrypt.Trim() != "")
            {
                byte[] keyArray;
                byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(dataToEncrypt);
                MD5CryptoServiceProvider hashmd5 = new MD5CryptoServiceProvider();
                keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(Cryptography.SECURITYKEY));
                hashmd5.Clear();
                TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider();
                tdes.Key = keyArray;
                tdes.Mode = CipherMode.ECB;
                tdes.Padding = PaddingMode.PKCS7;
                ICryptoTransform cTransform = tdes.CreateEncryptor();
                byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
                tdes.Clear();
                return Convert.ToBase64String(resultArray, 0, resultArray.Length);
            }
            else
                return dataToEncrypt;
        }
      
        public static string Decrypt(string dataToDecrypt)
        {
            if (IsBase64String(dataToDecrypt))
            {
                if (dataToDecrypt != null && dataToDecrypt.Trim() != "")
                {
                    byte[] keyArray;
                    byte[] toDecryptArray = Convert.FromBase64String(dataToDecrypt);
                    MD5CryptoServiceProvider hashmd5 = new MD5CryptoServiceProvider();
                    keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(Cryptography.SECURITYKEY));
                    hashmd5.Clear();
                    TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider();
                    tdes.Key = keyArray;
                    tdes.Mode = CipherMode.ECB;
                    tdes.Padding = PaddingMode.PKCS7;
                    ICryptoTransform cTransform = tdes.CreateDecryptor();
                    byte[] resultArray = cTransform.TransformFinalBlock(toDecryptArray, 0, toDecryptArray.Length);
                    tdes.Clear();
                    return UTF8Encoding.UTF8.GetString(resultArray);
                }
                else
                    return dataToDecrypt;
            }
            else
                return dataToDecrypt;
        }

   
        public static bool IsBase64String(this string s)
        {
            s = s.Trim();
            return (s.Length % 4 == 0) && Regex.IsMatch(s, @"^[a-zA-Z0-9\+/]*={0,3}$", RegexOptions.None);

        }
    }
}