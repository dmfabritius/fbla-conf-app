using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace FBLA_Conference_System
{
    public class Global : System.Web.HttpApplication
    {
        private static readonly string EncryptionKey = "MySecretKey";
        private static readonly byte[] SALT = new byte[] { 0x26, 0xd0, 0xf9, 0x68, 0x7a, 0x4d, 0x7a, 0x3c };

        public static string Encrypt(string clearText) {
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create()) {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, SALT);
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream()) {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write)) {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        public static string Decrypt(string cipherText) {
            try {
                byte[] cipherBytes = Convert.FromBase64String(cipherText);
                using (Aes encryptor = Aes.Create()) {
                    Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, SALT);
                    encryptor.Key = pdb.GetBytes(32);
                    encryptor.IV = pdb.GetBytes(16);
                    using (MemoryStream ms = new MemoryStream()) {
                        using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write)) {
                            cs.Write(cipherBytes, 0, cipherBytes.Length);
                            cs.Close();
                        }
                        cipherText = Encoding.Unicode.GetString(ms.ToArray());
                    }
                }
                return cipherText;
            } catch {
                return "false";
            }
        }

        void Application_Start(object sender, EventArgs e)
        {
            // Delete any files that may be left over in the pdf report folder
            /*
            string[] fileEntries = Directory.GetFiles(
                AppDomain.CurrentDomain.BaseDirectory + "pdf\\", "*.*",
                SearchOption.TopDirectoryOnly);
            foreach (string fileName in fileEntries)
            {
                File.Delete(fileName);
            }
            */
        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown
        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs
        }

        void Session_Start(object sender, EventArgs e)
        {
            // Code that runs when a session starts. 
            // Note: The Session_Start event is raised only when the sessionstate mode
            // is set to InProc in the Web.config file. If session mode is set to StateServer 
            // or SQLServer, the event is not raised.
            Session.Timeout = 60;
            Session["UserType"] = "none";
        }

        void Session_End(object sender, EventArgs e)
        {
            // Code that runs when a session ends. 
            // Note: The Session_End event is raised only when the sessionstate mode
            // is set to InProc in the Web.config file. If session mode is set to StateServer 
            // or SQLServer, the event is not raised.

            /*
            // Delete any pdf files that were generated during the session
            string[] fileEntries = Directory.GetFiles(
                AppDomain.CurrentDomain.BaseDirectory + "pdf\\",
                Session.SessionID + "*.pdf",
                SearchOption.TopDirectoryOnly);
            foreach (string fileName in fileEntries) {
                File.Delete(fileName);
            }
            */
        }
    }
}
