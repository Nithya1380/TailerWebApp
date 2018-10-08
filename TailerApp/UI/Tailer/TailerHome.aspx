<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TailerHome.aspx.cs" Inherits="TailerApp.UI.Tailer.TailerHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <style>
        .BranchDiv
        {
            z-index:101;
        }

        .BlackOverlay
{
    height: 0%;
    width: 100%;
    position: fixed;
    z-index: 1;
    top: 0;
    left: 0;
    background-color: rgba(0, 0, 0, .9);
    overflow-y: hidden;
    transition: 1s;
}
    </style>
    <script type="text/javascript">
        function OnAccountsClick() {
            window.location.href = "AccountMaster.aspx";
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row" style="margin-top:30px">
        <%--<div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">
                </div>
                <div class="panel-wrapper collapse in">
				<div class="panel-body">
                   <a href="#" onclick="OnAccountsClick()"><i class="fas fa-university  fa-w-16 fa-3x"> Accounts</i></a> 
                </div>
                </div>
            </div>
        </div>--%>
        
        <div id="div_BranchSelection" runat="server" style="display:none"></div>
    </div>
    <div class="BlackOverlay" id="div_overLay" runat="server" style="display:none"></div>
</asp:Content>
