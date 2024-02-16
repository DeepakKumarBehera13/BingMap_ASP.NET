using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DataTableCRUD
{
    public class OMS_OUTAGE_INFO
    {
        public int ID { get; set; }
        public string Status { get; set; }
        public string MeterNo { get; set; }
        public string InstallationID { get; set; } 
        public string InstallationType { get; set; }
        public string UtilityOfficeID { get; set; }
        public string GpsCord { get; set; }
        public string GisId { get; set; }   
        public string LastEventTime { get; set; } 
        public string EventCategory { get; set; }   
        public string SupplyPointID { get; set; }   
        public string SupplyPointName { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string UpdatedDate { get; set; }
        public string UpdatedBy { get; set; }
    }
}