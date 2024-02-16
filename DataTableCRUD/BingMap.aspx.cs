using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
namespace DataTableCRUD
{
    public partial class BingMap : System.Web.UI.Page
    {
        public string outputVal = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            dt = GetDataFromDataBase();
            string output = ConvertDataTableToJSON(dt);
            outputVal = output.ToString();
        }
        public DataTable GetDataFromDataBase()
        {
            DataTable dt = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Con"].ToString());
            string query = "SELECT GpsCord FROM OMS_OUTAGE_INFO WHERE(LastEventTime)IN (SELECT MAX(LastEventTime) FROM OMS_OUTAGE_INFO GROUP BY MeterNo)";
            SqlDataAdapter sda = new SqlDataAdapter(query, conn);
            sda.Fill(dt);
            return dt;
        }
        public string ConvertDataTableToJSON(DataTable dt)
        {
            JavaScriptSerializer jSonString = new JavaScriptSerializer();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            return jSonString.Serialize(rows);
        }
    }
}