﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Reflection;
using GeneralFrameworkBLL;

namespace GeneralFramework.WebServer
{
    /// <summary>
    /// UserLoginWebService 的摘要说明
    /// </summary>
    public class UserLoginWebService : IHttpHandler, IRequiresSessionState
    {

        HttpRequest Request;
        HttpResponse Response;
        HttpSessionState Session;
        HttpServerUtility Server;
        HttpCookie Cookie;
        SysUserManager sum = new SysUserManager();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.Buffer = true;
            context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1);
            context.Response.AddHeader("pragma", "no-cache");
            context.Response.AddHeader("cache-control", "");
            context.Response.CacheControl = "no-cache";
            context.Response.ContentType = "text/plain";

            Request = context.Request;
            Response = context.Response;
            Session = context.Session;
            Server = context.Server;


            string method = Request["method"].ToString();
            MethodInfo methodInfo = this.GetType().GetMethod(method);
            try
            {
                methodInfo.Invoke(this, null);
            }
            catch (TargetInvocationException targetEx)
            {
                if (targetEx.InnerException != null)
                {
                    throw targetEx.InnerException;
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public void Login()
        {
            string UserName = Request.Form["UserName"].ToString();
            string Pwd = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(Request.Form["Pwd"].ToString(), "MD5").ToLower();
            bool isLogin = sum.Islogin(UserName, Pwd);
            if (isLogin)
            {

                Session["UserName"] = UserName;
                Session.Timeout = 60;

            }
            Response.Write(isLogin);
        }

        public void GetLoginUserInfo()
        {
            Response.Write(Session["UserName"].ToString());
        }

        public void GetUserTBJson()
        {
            int DepartmentId = int.Parse(Request["DepartmentId"].ToString());
            Response.Write(sum.GetUserTBJsonForDepartmentId(DepartmentId));
        }

        public void EditUserPwd()
        {
            string UserName = Request.Form["UserName"].ToString();
            string Pwd = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(Request.Form["Pwd"].ToString(), "MD5").ToLower();
            Response.Write(sum.EditUserPwd(UserName, Pwd));
        }
    }
}