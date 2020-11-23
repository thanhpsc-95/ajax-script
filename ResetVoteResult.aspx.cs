using Newtonsoft.Json;
using NHibernate.Linq;
using PSCPortal.DB.DTO;
using PSCPortal.DB.DTO.StatisticDTO;
using PSCPortal.DB.Entities;
using PSCPortal.Framework;
using PSCPortal.Framework.Core;
using PSCPortal.Framework.DataAccess;
using PSCPortal.Helper;
using PSCPortal.Systems.Statistic.StatisticResult;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;

namespace PSCPortal.Systems.Statistic
{
    public partial class ResetVoteResult : PSCPage
    {
        public string CurrentPagePath { get; } = Path.GetFileName(HttpContext.Current.Request.Url.AbsolutePath);
        public string TitlePage = "Xoá kết quả khảo sát";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Page.Title))
            {
                Page.Title = ConfigurationManager.AppSettings["DefaultTitle"] ?? TitlePage;  //title saved in web.config
            }
        }

        protected static new string ConnectionStringName
        {
            get
            {
                return "PSCPortalConnectionString";
            }
        }

        public static List<Class> ClassList
        {
            get
            {
                if (DataStatic["ClassList"] == null)
                {
                    List<Class> result = new List<Class>();
                    List<Guid> ClassIdList = HttpContext.Current.Session["UserClassList"] as List<Guid>;
                    SessionManager.DoWork(session =>
                    {
                        List<Class> template = session.Query<PSCPortal.DB.Entities.Class>().ToList();
                        foreach (Class org in template)
                        {
                            //if (ClassIdList.Contains(org.Id))
                            //    result.Add(org);
                        }
                        DataStatic["ClassList"] = result;
                    });
                }
                return DataStatic["ClassList"] as List<PSCPortal.DB.Entities.Class>;
            }
        }

        [WebMethod]
        public static string GetDepartmentList()
        {

            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            return js.Serialize(StatisticHelper.GetDepartmentList());
        }

        [WebMethod]
        public static string GetListClass()
        {

            List<ClassDTO> modelDTO = new List<ClassDTO>();
            //SessionManager.DoWork(session =>
            //{
            //    List<Class> classList = session.Query<Class>().ToList();
            //    modelDTO = classList.Map<ClassDTO>();          
            //});
            List<Class> classList = StatisticHelper.GetClassListByUser();
            modelDTO = classList.Map<ClassDTO>();
            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            return js.Serialize(modelDTO);
        }

        [WebMethod]
        public static string Vote_Detail(Guid voteFormId, string departmentId, string ologyId, DateTime TuNgay, DateTime DenNgay)
        {
            Statistic_VoteFormDTO result = GeneralResult.GetVoteCollection(voteFormId, departmentId, ologyId, TuNgay, DenNgay);
            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            return js.Serialize(result);
        }
        [WebMethod]
        public static string Vote_Details(Guid voteFormId, string departmentId, string ologyId)
        {

            Statistic_VoteFormDTO result = GeneralResult.GetVoteCollections(voteFormId, departmentId, ologyId);
            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            return js.Serialize(result);
        }
        [WebMethod]
        public static string GetStudyYears()
        {
            var result = "";
            SessionManager.DoWork(session =>
            {
                List<StudyYear> studyYears = session.Query<StudyYear>().ToList();
                result = JsonConvert.SerializeObject(studyYears);
            });
            return result;
        }

        [WebMethod]
        public static string GetVoteForms(string studyYearId, string classId)
        {
            var result = "";
            SessionManager.DoWork(session =>
            {
                List<DB.Entities.VoteForm> studyYears = new List<PSCPortal.DB.Entities.VoteForm>();
                if (studyYearId == "All")
                {
                    studyYears = session.Query<PSCPortal.DB.Entities.VoteForm>().ToList();
                }
                else
                {
                    studyYears = session.Query<PSCPortal.DB.Entities.VoteForm>().Where(v => v.StudyYearId == studyYearId && v.ClassId == Convert.ToInt32(classId) && v.IsDeleted == false).ToList();
                }
                result = JsonConvert.SerializeObject(studyYears);
            });
            return result;
        }

        [WebMethod]
        public static string GetVotedUserList(int classId, DateTime startDate, DateTime endDate, string userId, string departmentId)
        {
            Dictionary<string, object> dicResult = new Dictionary<string, object>();
            startDate = new DateTime(startDate.Year, startDate.Month, startDate.Day, 0, 0, 0);
            endDate = new DateTime(endDate.Year, endDate.Month, endDate.Day, 23, 59, 59);
            List<VotedUserDTO> result = StatisticHelper.GetVotedUserList(classId, startDate, endDate, userId, departmentId, "-1");
            dicResult["Data"] = result;
            dicResult["Count"] = result.Count;
            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            return js.Serialize(dicResult);
        }


        [WebMethod]
        public static string GetOlogyList(string classId, string departmentId)
        {
            string result;
            //if (departmentId != "-1")
            //{
            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            if (classId == "10")
                result = js.Serialize(StatisticHelper.GetSubDepartmentByDepartment(departmentId));
            else
                result = js.Serialize(StatisticHelper.GetOlogyListByDepartment(departmentId));
            //}
            return result;
        }

        [WebMethod]
        public static string GetVoteResults(Guid voteFormId, string departmentId, string ologyId)
        {
            bool isObligate = StatisticHelper.IsObligateVoteForm(voteFormId);
            List<VotedUserDTO> voteUserList = new List<VotedUserDTO>();
            int totalRowCount = GeneralResult.GetVoteResults(voteFormId, departmentId, ologyId).Count();
            List<Statistic_VoteResultDTO> voteResults = GeneralResult.GetVoteResults(voteFormId, departmentId, ologyId).ToList();
            if (isObligate)
            {
                voteUserList = GeneralResult.GetAllVotedUserList_Obligate(voteFormId, departmentId, ologyId, DateTime.MinValue.AddYears(1899), DateTime.Now, "-1");
            }
            else
            {
                voteUserList = GeneralResult.GetAllVotedUserList(voteFormId, departmentId, ologyId, DateTime.MinValue.AddYears(1899), DateTime.Now);
            }
            var voteResultUserList = (from vote in voteResults
                                      from user in voteUserList
                                      where (vote.UserId == user.Id && vote.VoteObjectId.Equals(user.MLHP, StringComparison.OrdinalIgnoreCase))
                                      select new
                                      {
                                          vote.VoteFormId,
                                          vote.Id,
                                          vote.UserId,
                                          vote.VoteObjectId,
                                          vote.VoteTime,
                                          user.Name,
                                          user.DepartmentId,
                                          user.DepartmentName,
                                          user.OlogyId,
                                          user.OlogyName,
                                          user.ClassStudentID,
                                          user.ClassStudentName
                                      }).ToList();
            Dictionary<string, object> resultDics = new Dictionary<string, object>();
            resultDics.Add("draw", 0);
            resultDics.Add("recordsTotal", totalRowCount);
            resultDics.Add("recordsFiltered", totalRowCount);
            resultDics.Add("data", voteResultUserList);
            return JsonConvert.SerializeObject(resultDics);
        }

        [WebMethod]
        public static string DeleteVoteResult(Guid voteResultId)
        {
            bool voteResults = GeneralResult.DeleteVoteResult(voteResultId);
            return JsonConvert.SerializeObject(voteResults);
        }
    }
}