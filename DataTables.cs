using PSCPortal.DB.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace PSCPortal.Helper
{
    public class DataTables
    {
        public int draw { get; set; }
        public int recordsTotal { get; set; }
        public int recordsFiltered { get; set; }
        //public List<VoteResultUser> data { get; set; }
        public DataTable data { get; set; }
    }
}