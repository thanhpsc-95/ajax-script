using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using PSCPortal.DB.DTO;
using PSCPortal.DB.DTO.StatisticDTO;
using PSCPortal.Systems.Statistic.StatisticResult;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

namespace PSCPortal.Helper
{
    /// <summary>
    /// Summary description for ServerHandler
    /// </summary>
    public class ServerHandler : IHttpHandler
    {
        private static string connectionString
        {
            get
            {
                return System.Configuration.ConfigurationManager.ConnectionStrings["PSCPortalConnectionString"].ConnectionString;
            }
        }
        public void ProcessRequest(HttpContext context)
        {
            context.Response.Clear();
            context.Response.ContentType = "application/json";
            context.Response.Charset = "UTF-8";
            var result = JsonConvert.SerializeObject(GetVoteResults());
            context.Response.Write(result);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        #region Tìm kiếm kết quả khảo sát
        /// <summary>
        /// Tìm kiếm kết quả khảo sát
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        public object GetVoteResults()
        {
            DataTables result = new DataTables();
            result.data = new DataTable();
            JObject jsonData2;
            try
            {
                using (System.IO.Stream stream = HttpContext.Current.Request.InputStream)
                using (System.IO.StreamReader reader = new System.IO.StreamReader(stream))
                {
                    stream.Seek(0, System.IO.SeekOrigin.Begin);
                    string bodyText = reader.ReadToEnd();
                    jsonData2 = (JObject)JsonConvert.DeserializeObject(bodyText);
                }
                DataTable data = new DataTable();
                if (jsonData2 != null)
                {
                    string search = Regex.Replace(jsonData2["search"]["value"].ToString(), @"\s{2,}", " ").TrimStart(' ').TrimEnd(' ');
                    string draw = jsonData2["draw"].ToString();//draw
                    string order = jsonData2["order"][0]["column"].ToString(); //order[0][column]
                    string orderDir = jsonData2["order"][0]["dir"].ToString();//order[0][dir]
                    string sortColumnName = jsonData2["columns"][int.Parse(order)]["data"].ToString();
                    int startRec = int.Parse(jsonData2["start"].ToString());//start
                    int pageSize = int.Parse(jsonData2["length"].ToString());//length
                    Guid voteFormId = !string.IsNullOrEmpty(jsonData2["voteFormId"].ToString()) ? Guid.Parse(jsonData2["voteFormId"].ToString()) : Guid.Empty;
                    string departmentId = !string.IsNullOrEmpty(jsonData2["departmentId"].ToString()) ? jsonData2["departmentId"].ToString() : "-1";
                    string ologyId = !string.IsNullOrEmpty(jsonData2["ologyId"].ToString()) ? jsonData2["ologyId"].ToString() : "-1";
                    bool isObligate = StatisticHelper.IsObligateVoteForm(voteFormId);
                    int totalRecords = 0;
                    int recFilter = 0;
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();
                        using (SqlCommand cmd = new SqlCommand("sp_VoteResultUserInfor", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@VoteFormId", voteFormId.ToString());
                            cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                            cmd.Parameters.AddWithValue("@OlogyId", ologyId);
                            cmd.Parameters.AddWithValue("@TuNgay", DateTime.MinValue.AddYears(1899));
                            cmd.Parameters.AddWithValue("@DenNgay", DateTime.Now);
                            cmd.Parameters.AddWithValue("@SearchString", search);
                            cmd.Parameters.AddWithValue("@PageSize", pageSize);
                            cmd.Parameters.AddWithValue("@PageStart", startRec);
                            cmd.Parameters.AddWithValue("@SortColumn", sortColumnName);
                            cmd.Parameters.AddWithValue("@SortType", orderDir);

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.HasRows)
                                {
                                    DataTable dt = new DataTable();
                                    dt.Clear();
                                    dt.Load(reader);
                                    data = dt;
                                    while (reader.Read())
                                    {
                                        totalRecords = DatabaseHelper.ContainsColumn(reader, "recordsTotal") ? int.Parse(reader["recordsTotal"].ToString()) : 0;
                                    }
                                    reader.NextResult();
                                    while (reader.Read())
                                    {
                                        recFilter = DatabaseHelper.ContainsColumn(reader, "recordsFiltered") ? int.Parse(reader["recordsFiltered"].ToString()) : 0;
                                    }
                                }
                            }
                        }
                        con.Close();
                    }
                    result.draw = Convert.ToInt32(draw);
                    result.recordsTotal = totalRecords;
                    result.recordsFiltered = recFilter;
                    result.data = data;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return result;
        }
        #endregion
    }
}