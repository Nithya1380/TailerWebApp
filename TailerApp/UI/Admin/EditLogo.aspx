<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditLogo.aspx.cs" Inherits="TailerApp.UI.Admin.EditLogo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Logo</title>
    <link href="../Style/bootstrap.min.css" rel="stylesheet" />
    <style>
        
    #wrapper
    {
        float:left;
        width:100%;
        font-family:"Masterics_Personal_Use", sans-serif;
	    font-size:12px;
    }

    </style>
    
    <script language="javascript" type="text/javascript">

        function Close() {
            window.close();
            return false;
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="wrapper">
        <div class="card border-light mb-3">
            <div class="card-header h5">Edit Company Logo</div>
             <div class="card-body">
                  
        <div id="content_div" style="margin-top:10px; float:left; width:100%">
          <table  style="width:98%; margin:auto">
          <tr>
          <td  align="center"><asp:Image ID="img_Logo" class="rounded mx-auto d-block" alt="..." runat="server" Width="225" Height="80" ImageUrl="../Img/LogoPrivew.png" /> 
          </td>
           </tr>
           <tr style="height:10px"><td></td></tr>
           <tr>
          <td align="center"><b>Choose Logo:&nbsp;</b><input  class="popup_upload" id="UploadingFileName_Txt" type="file" name="UploadingFileName_Txt" runat="server" 
                                                style="width:200px" /> </td>
          </tr>
          <tr>
          <td align="center">
           Logo Dimension: (225 x 80) - 300 DPI</td>
          </tr>
              <tr style="height:10px"><td></td></tr>
          <tr>
          <td colspan="2" align="center">
              <asp:Button ID="btn_Remove" class="btn btn-danger" runat="server" Text="Remove" OnClick="btn_Remove_Click" /> 
              <asp:Button ID="btn_Save" class="btn btn-success" runat="server" Text="Save" OnClick="btn_Upload_Click" /> 
              <asp:Button ID="btn_Close" class="btn btn-secondary" runat="server" Text="Close" OnClientClick="return Close();" /> 
          </td>
          </tr>
          </table>
        </div>
    </div>
    </div>
    </div>
    </form>
</body>
</html>
