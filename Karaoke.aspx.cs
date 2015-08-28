using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Bubbarome
{
    public partial class Karaoke : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#AAFF00'");
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle");
                e.Row.Attributes.Add("style", "cursor:pointer;");
                e.Row.Attributes["onClick"] = "window.location = 'FindByArtist.asp?Artist=" + e.Row.Cells[0].Text.ToString().Trim() + "';";
            }
        }
    }
}
