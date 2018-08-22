<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TailerHome.aspx.cs" Inherits="TailerApp.UI.Tailer.TailerHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script type="text/javascript">
        function OnAccountsClick() {
            window.location.href = "AccountMaster.aspx";
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row" style="margin-top:30px">
        <div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">
                </div>
                <div class="panel-wrapper collapse in">
				<div class="panel-body">
                   <a href="#" onclick="OnAccountsClick()"><i class="fas fa-university  fa-w-16 fa-3x"> Accounts</i></a> 
                </div>
                </div>
            </div>
        </div>
        
    </div>
    
</asp:Content>
