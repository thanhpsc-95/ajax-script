using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.ModelBinding;

namespace PSCPortal.Helper
{
    public static class DatabaseHelper
    {
        /// <summary>
        /// Hàm chuyển đổi sang DataTable từ List<T>
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="itemSources"></param>
        /// <returns></returns>
        public static DataTable ToDataTable<T>(List<T> itemSources)

        {

            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties

            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

            foreach (PropertyInfo prop in Props)

            {

                //Setting column names as Property names

                dataTable.Columns.Add(prop.Name);

            }

            foreach (T item in itemSources)

            {

                var values = new object[Props.Length];

                for (int i = 0; i < Props.Length; i++)

                {

                    //inserting property values to datatable rows

                    values[i] = Props[i].GetValue(item, null);

                }

                dataTable.Rows.Add(values);

            }

            //put a breakpoint here and check datatable

            return dataTable;

        }
        /// <summary>
        /// Hàm chuyển DataReader sang List<T>
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="dr"></param>
        /// <returns></returns>
        public static List<T> DataReaderMapToList<T>(IDataReader dr)
        {
            List<T> list = new List<T>();
            T obj = default(T);
            while (dr.Read())
            {
                obj = Activator.CreateInstance<T>();
                foreach (PropertyInfo prop in obj.GetType().GetProperties())
                {
                    if (!object.Equals(dr[prop.Name], DBNull.Value))
                    {
                        prop.SetValue(obj, dr[prop.Name], null);
                    }
                }
                list.Add(obj);
            }
            return list;
        }
        /// <summary>
        /// Kiểm tra giá trị của cột là DBNull
        /// </summary>
        /// <param name="dataReader">The data reader</param>
        /// <param name="columnName">The column name</param>
        /// <returns>A bool indicating if the column's value is DBNull</returns>
        public static bool IsDBNull(this IDataReader dataReader, string columnName)
        {
            return dataReader[columnName] == DBNull.Value;
        }

        /// <summary>
        /// Kiểm tra cột có tồn tại hay không
        /// </summary>
        /// <param name="dataReader">The data reader</param>
        /// <param name="columnName">The column name</param>
        /// <returns>A bool indicating the column exists</returns>
        public static bool ContainsColumn(this IDataReader dataReader, string columnName)
        {
            try
            {
                return dataReader.GetOrdinal(columnName) >= 0;
            }
            catch (IndexOutOfRangeException)
            {
                return false;
            }
        }
        /// <summary>
        /// Chuyển đổi object sang query string
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static string ToQueryString(this object obj)
        {

            var qs = new StringBuilder("?");

            var objType = obj.GetType();

            var properties = objType.GetProperties()
                                    .Where(p => Attribute.IsDefined(p, typeof(QueryStringAttribute)) && p.GetValue(obj, null) != null);

            foreach (var prop in properties)
            {
                var name = prop.Name;
                var value = prop.GetValue(obj);

                qs.Append($"{Uri.EscapeDataString(name)}={Uri.EscapeDataString((string)value)}&");
            }
            return qs.ToString();
        }
    }
}