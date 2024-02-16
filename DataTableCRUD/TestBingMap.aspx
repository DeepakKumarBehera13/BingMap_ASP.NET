<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestBingMap.aspx.cs" Inherits="DataTableCRUD.TestBingMap" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bing Map</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type='text/javascript' src='http://www.bing.com/api/maps/mapcontrol?branch=release&callback=GetMap async defer'></script> 
    <script type="text/javascript">
        function GetMap()
        {
            var key = "AkjunEULgplSBPVCyUGLC9FbYvBgO8sNpB5pjKat1fCDVZ4S1JIyso9jfUm8zLSC";
            var mapOptions = { credentials: key, mapTypeId: Microsoft.Maps.MapTypeId.road, zoom: 15 }
            var infobox = null;
            var map = new Microsoft.Maps.Map('#myMap', mapOptions);
        }
        function showInfobox(e)
        {
                if (e.target.metadata) {
                    infobox.setOptions({
                        location: e.target.getLocation(),
                        title: e.target.metadata.title,
                        description: e.target.metadata.description,
                        visible: true
                    });
                }
            }

        function hideInfobox(e)
        {
            infobox.setOptions({ visible: false });
        }

        function addMarker()
        {
            var marker = new Microsoft.Maps.Pushpin(new Microsoft.Maps.Location(20.29804356124038, 85.83128421026865), { color: 'red' });
                infobox = new Microsoft.Maps.Infobox(marker.getLocation(),
                {
                    visible: true
                });
                marker.metadata = {
                    id: 1,
                    title: 'OCAC TOWER',
                    description: 'Acharya Vihar, Bhubaneswar, Odisha'
                };
                Microsoft.Maps.Events.addHandler(marker, 'mouseout', hideInfobox);
                Microsoft.Maps.Events.addHandler(marker, 'mouseover', showInfobox);
                infobox.setMap(map);
                map.entities.push(marker);
                marker.setOptions({ enableHoverStyle: true });
            };
    </script>
</head>
<body onload="GetMap();">
<input type="button" value="Show Points" onclick="addMarker();" />
<div id="myMap" style='position: relative; width: 1300px; height: 800px;'></div>
</body>
</html>

