<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BingMap.aspx.cs" Inherits="DataTableCRUD.BingMap" %>

<!DOCTYPE html>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Services" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bing Map</title>
    <style type="text/css">
        html 
        {
            height: 100%;
        }
        body 
        {
            height: 100%;
            margin: 0;
            padding: 0;
        }
        #myMap 
        {
            height: 100%;
        }
    </style>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type='text/javascript' src='http://www.bing.com/api/maps/mapcontrol?branch=release&callback=GetMap async defer'></script> 
    <script src="DataTables/jQuery-3.6.0/jquery-3.6.0.js"></script>
    <script src="DataTables/DataTables-1.13.2/js/jquery.dataTables.js"></script>
    <link href="DataTables/DataTables-1.13.2/css/jquery.dataTables.css" rel="stylesheet" />
    <link href="DataTables/Bootstrap-4-4.6.0/css/bootstrap.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" media="all" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" />
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>

    <!-- Sever Side scripting -->
        <script runat="server">
            [WebMethod]
            public static string GetTableData()
            {
                StringBuilder strJson = new StringBuilder("{ \"data\":  [ ");
                SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["Con"].ConnectionString);
                using (Con)
                {
                    string strComma = "";
                    string sql = "SELECT * FROM OMS_OUTAGE_INFO WHERE(LastEventTime)IN (SELECT MAX(LastEventTime) FROM OMS_OUTAGE_INFO GROUP BY MeterNo)";
                    SqlCommand cmd = new SqlCommand(sql, Con);
                    using (cmd)
                    {
                        Con.Open();
                        SqlDataReader rdr = cmd.ExecuteReader();
                        using (rdr)
                        {
                            while (rdr.Read())
                            {
                                strJson.Append(strComma);
                                if (strComma == "") strComma = ", ";
                                strJson.Append("{");
                                strJson.AppendFormat("  \"ID\": \"{0}\" ", rdr["ID"]);
                                strJson.AppendFormat(", \"Status\": \"{0}\" ", rdr["Status"]);
                                strJson.AppendFormat(", \"MeterNo\": \"{0}\" ", rdr["MeterNo"]);
                                strJson.AppendFormat(", \"InstallationID\": \"{0}\" ", rdr["InstallationID"]);
                                strJson.AppendFormat(", \"InstallationType\": \"{0}\" ", rdr["InstallationType"]);
                                strJson.AppendFormat(", \"UtilityOfficeID\": \"{0}\" ", rdr["UtilityOfficeID"]);
                                strJson.AppendFormat(", \"GpsCord\": \"{0}\" ", rdr["GpsCord"]);
                                strJson.AppendFormat(", \"GisId\": \"{0}\" ", rdr["GisId"]);
                                strJson.AppendFormat(", \"LastEventTime\": \"{0}\" ", rdr["LastEventTime"]);
                                strJson.AppendFormat(", \"EventCategory\": \"{0}\" ", rdr["EventCategory"]);
                                strJson.AppendFormat(", \"SupplyPointID\": \"{0}\" ", rdr["SupplyPointID"]);
                                strJson.AppendFormat(", \"SupplyPointName\": \"{0}\" ", rdr["SupplyPointName"]);
                                strJson.AppendFormat(", \"CreatedBy\": \"{0}\" ", rdr["CreatedBy"]);
                                strJson.AppendFormat(", \"CreatedDate\": \"{0}\" ", rdr["CreatedDate"]);
                                strJson.AppendFormat(", \"UpdatedDate\": \"{0}\" ", rdr["UpdatedDate"]);
                                strJson.AppendFormat(", \"UpdatedBy\": \"{0}\" ", rdr["UpdatedBy"]);
                                strJson.Append("}");
                            }
                        }
                        Con.Close();
                    }
                }
                strJson.Append("] }");
                return strJson.ToString();
            }
        </script>

    <script type="text/javascript">
        var map;
        var infobox = null;
        var markers = <%=outputVal%>;
        var coords = JSON.stringify(markers);
        /*alert(coords);*/
        function GetMap()
        {
            var key = "Ao9zaL2VhbQFk1BFQvT6hpb_5kpnJTEZoCvnSzxfEUTS0pHAoVhHAylL8Z7ZGVtY";
            var mapOptions = { credentials: key, mapTypeId: Microsoft.Maps.MapTypeId.road, zoom: 15 }
            map = new Microsoft.Maps.Map('#myMap', mapOptions);
        }
        function showInfobox(e)
        {
            if (e.target.location)
            {
                infobox.setOptions({
                location: e.target.getLocation(),
                visible: true
                });
            }
        }

        function hideInfobox(e)
        {
            infobox.setOptions({ visible: false });
        }

        <%--function addMarker(latitude, longitude)
        { 
            debugger;
            var markers = <%=outputVal%>;
            var coords = JSON.stringify(markers);
            var value1 = coords.replace(/[{()}]/g, '');
            var value2 = value1.replace('"GpsCord"', '');
            var value3 = value2.replace(/:/g, '');
            var value4 = value3.replace('["20.28876622,85.84242766"]', '"20.28876622,85.84242766"');
            var value5 = value4.replace('"20.28876622,85.84242766"', '20.28876622,85.84242766');
            var latlng = value5.split(",");
            var latitude = latlng[0];
            var longitude = latlng[1];
            var location = new Microsoft.Maps.Location(latitude,longitude);
            var pin = new Microsoft.Maps.Pushpin(location);
            map.entities.push(pin);
            pin.setOptions({ enableHoverStyle: true });
            infobox = new Microsoft.Maps.Infobox(pin.getLocation(),
            {
              visible: true
            });
            Microsoft.Maps.Events.addHandler(pin, 'mouseout', hideInfobox);
            Microsoft.Maps.Events.addHandler(pin, 'mouseover', showInfobox);
            infobox.setMap(map);
            map.entities.push(pin);
            pin.setOptions({ enableHoverStyle: true });  
        };--%>

        function addMarker(markers)
        {
            debugger;
            var gpscord;
            var gpslat;
            var gpslong;
            var str = '';
            var i = 0;
            markers.forEach(function (item)
            {
                str += '<tr>';
                for (const key in item)
                {
                 str += '<td>';
                 if (item[key] == null)
                 str += "";
                 else
                 gpscord = item[key];
                 gpslat = gpscord.split(',')[0];
                 gpslong = gpscord.split(',')[1];
                 str += gpscord;
                 str += '</td>';
                }
                str += '</tr>';
                i++;
            });
            var location = new Microsoft.Maps.Location(gpslat, gpslong);
            var pin = new Microsoft.Maps.Pushpin(location);
            map.entities.push(pin);
            pin.setOptions({ enableHoverStyle: true });
            infobox = new Microsoft.Maps.Infobox(pin.getLocation(),
                {
                    visible: true
                });
            Microsoft.Maps.Events.addHandler(pin, 'mouseout', hideInfobox);
            Microsoft.Maps.Events.addHandler(pin, 'mouseover', showInfobox);
            infobox.setMap(map);
            map.entities.push(pin);
            pin.setOptions({ enableHoverStyle: true });  
            return str;
        };
        //function pin(gpslat, gpslong) {
        //    debugger;
        //    var location = new Microsoft.Maps.Location(gpslat, gpslong);
        //    alert(location);
        //    var pin = new Microsoft.Maps.Pushpin(location);
        //    map.entities.push(pin);
        //    pin.setOptions({ enableHoverStyle: true });
        //    infobox = new Microsoft.Maps.Infobox(pin.getLocation(),
        //        {
        //            visible: true
        //        });
        //    Microsoft.Maps.Events.addHandler(pin, 'mouseout', hideInfobox);
        //    Microsoft.Maps.Events.addHandler(pin, 'mouseover', showInfobox);
        //    infobox.setMap(map);
        //    map.entities.push(pin);
        //    pin.setOptions({ enableHoverStyle: true });  
        //}
    </script>
</head>
<body onload="GetMap();">
    <h2>Data Table Record's List</h2>
        <table id="tbl_OMS" class="display" style="width:100%">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Status</th>
                    <th>MeterNo</th>
                    <th>InstallationID</th>
                    <th>InstallationType</th>
                    <th>UtilityOfficeID</th>
                    <th>GpsCord</th>
                    <th>GisId</th>
                    <th>LastEventTime</th>
                    <th>EventCategory</th>
                    <th>SupplyPointID</th>
                    <th>SupplyPointName</th>
                    <th>CreatedBy</th>
                    <th>CreatedDate</th>
                    <th>UpdatedDate</th>
                    <th>UpdatedBy</th>
                </tr>
            </thead> 
            <tbody></tbody>
        </table>
        <script type="text/javascript">
            $(document).ready(function () {
                $('#tbl_OMS').DataTable({
                    "ajax": {
                        url: "BingMap.aspx/GetTableData",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        dataSrc: function (response) { return JSON.parse(response.d).data; },
                        error: function (response) { alert("error: " + response.d); }
                    }
                    ,
                    "columns": [
                        { "data": "ID" },
                        { "data": "Status" },
                        { "data": "MeterNo" },
                        { "data": "InstallationID" },
                        { "data": "InstallationType" },
                        { "data": "UtilityOfficeID" },
                        { "data": "GpsCord" },
                        { "data": "GisId" },
                        { "data": "LastEventTime" },
                        { "data": "EventCategory" },
                        { "data": "SupplyPointID" },
                        { "data": "SupplyPointName" },
                        { "data": "CreatedBy" },
                        { "data": "CreatedDate" },
                        { "data": "UpdatedDate" },
                        { "data": "UpdatedBy" }
                    ]
                });
            });
        </script>
<input type="button" value="Show Points" onclick="addMarker(markers);" />
<div id="myMap" style='position: relative; width: 1350px; height: 450px;'></div>
</body>
</html>
