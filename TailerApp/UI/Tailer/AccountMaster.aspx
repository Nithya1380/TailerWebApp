<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccountMaster.aspx.cs" Inherits="TailerApp.UI.Tailer.AccountMaster" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet">
    <div class="row">
  		<div class="col-sm-10"><h3>Company Name</h3></div>
    </div>
    <div class="row">
  		<div class="col-sm-2">
            <!--left col-->

            <div class="text-center">
                <img src="http://ssl.gstatic.com/accounts/ui/avatar_2x.png" class="avatar img-circle img-thumbnail" alt="avatar">
                <h6>Upload a different photo...</h6>
                <input type="file" class="text-center center-block file-upload">
            </div>
            <br>
        </div>
        <!--/col-3-->
    	<div class="col-sm-10">
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#accountTab">Account</a></li>
                <li><a data-toggle="tab" href="#customerTab">Customer</a></li>
                <li><a data-toggle="tab" href="#loyaltyTab">Loyalty Gift</a></li>
                <li><a data-toggle="tab" href="#customerAndBranchTab">Company & Branch</a></li>
                <li><a data-toggle="tab" href="#cardPrintTab">Card Print</a></li>
                <li><a data-toggle="tab" href="#supplierTab">Supplier</a></li>
              </ul>

              
          <div class="tab-content">
            <div class="tab-pane active" id="accountTab">
                <br />
                <div class="form-horizontal">
                    <div class="form-group row">
                        <label class="checkbox-inline col-sm-2" style="font-weight: bold;">
                            <input type="checkbox" class="checkbox" name="chkCommonAccount" id="chkCommonAccount" />Common Account
                        </label>
                        <label class="checkbox-inline col-sm-2" style="font-weight: bold;">
                            <input type="checkbox" class="checkbox" name="chkActiveAccount" id="chkActiveAccount" />Active Account
                        </label>
                    </div>

                    <div class="form-group row">
                        <label for="txtAccountCode" class="col-sm-2">Account Code</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="first_name" id="txtAccountCode" placeholder="Account Code" title="enter your Account Code.">
                        </div>

                        <label for="txtAccountName" class="col-sm-2">Account Name</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="first_name" id="txtAccountName" placeholder="Account Name" title="enter your Account Code.">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="drpAccountType" class="col-sm-2">Account Type</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="drpAccountType">
                                <option>Select Account Type</option>
                            </select>
                        </div>

                        <label for="drpParentGroup" class="col-sm-2">Parent Group</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="drpParentGroup">
                                <option>Select Parent Group</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="drpCategory" class="col-sm-2">Category</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="drpCategory">
                                <option>Select Category</option>
                            </select>
                        </div>

                        <label for="txtPartyAlert" class="col-sm-2">Party Alert</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="txtPartyAlert" id="txtPartyAlert" placeholder="Party Alert" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="txtOpening" class="col-sm-2">Opening</label>
                        <div class="col-sm-4">
                            <input type="number" class="form-control" name="txtOpening" id="txtOpening" style="display: inline !important; width: 90%" />Cr.
                        </div>

                        <label for="txtClosing" class="col-sm-2">Closing</label>
                        <div class="col-sm-4">
                            <input type="number" class="form-control" name="txtClosing" id="txtClosing" style="display: inline !important; width: 90%" />Cr.
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="txtCreatedDate" class="col-sm-2">Created Date</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="txtCreatedDate" id="txtCreatedDate" placeholder="Created Date" />
                        </div>
                        <div class="col-sm-6">
                            <select class="form-control" id="drpDateCategory">
                                <option>Select Category</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="checkbox-inline col-sm-2" style="font-weight: bold;">
                            <input type="checkbox" class="checkbox" name="last_name" id="chkTDSApplicable" />TDS Applicable
                        </label>
                        <label for="drpTDSCategory" class="col-sm-2" style="text-align: right">TDS Category</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="drpTDSCategory">
                                <option>Select Category</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="drpDefault" class="col-sm-2">Default</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="drpDefault">
                                <option>Select Default</option>
                            </select>
                        </div>

                        <label for="drpReverse" class="col-sm-2">Reverse</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="drpReverse">
                                <option>Select Reverse</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="drpSch6Group" class="col-sm-2">Sch6 Group</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="drpSch6Group">
                                <option>Select Sch6 Group</option>
                            </select>
                        </div>

                        <label for="txtSch6AccountNo" class="col-sm-2">Sch6 Account No</label>
                        <div class="col-sm-4">
                            <input type="number" class="form-control" name="txtOpening" id="txtSch6AccountNo" />
                        </div>
                    </div>

                </div>

                <div class="form-group">
                    <div class="col-xs-6">
                        <br />
                        <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Save</button>
                    </div>
                </div>
                <hr>
            </div>
                <!--/tab-pane-->
                <div class="tab-pane" id="customerTab">
                    <br />
                    <div class="form-horizontal">
                        <div class="form-group row">
                            <label for="txtFullName" class="col-sm-2">Full Name</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtFullName" id="txtFullName" placeholder="Full Name" title="enter your Full Name.">
                            </div>
                            <label for="drpSex" class="col-sm-2">Sex</label>
                            <div class="col-sm-4">
                               <select class="form-control" id="drpSex">
                                   <option>Male</option>
                                   <option>Female</option>
                               </select>
                            </div>
                        </div>
                         <div class="form-group row">
                            <label for="txtFirstName" class="col-sm-2">First Name</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtFullName" id="txtFirstName" placeholder="First Name" title="enter your First Name.">
                            </div>
                             <label for="txtLastName" class="col-sm-2">Last Name</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtLastName" id="txtLastName" placeholder="Last Name" title="enter your Last Name." />
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="txtSurName" class="col-sm-2">Sur Name</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtSurName" id="txtSurName" placeholder="Sur Name" title="enter your Sur Name." />
                            </div>
                            <label for="txtContactPerson" class="col-sm-2">Contact Person</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtContactPerson" id="txtContactPerson" placeholder="Contact Person" title="enter Contact Person Name." />
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="txtBirthDate" class="col-sm-2">Birth Date</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtBirthDate" id="txtBirthDate" placeholder="Birth Date" title="enter Birth Date." />
                            </div>
                            <label for="txtOpenDate" class="col-sm-2">Open Date</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtOpenDate" id="txtOpenDate" placeholder="Open Date" title="enter Open Date." />
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="txtAddress1" class="col-sm-2">Address 1</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtAddress1" id="txtAddress1" placeholder="Address 1" />
                            </div>
                            <label for="txtAddress2" class="col-sm-2">Address 2</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtAddress2" id="txtAddress2" placeholder="Address 2" />
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="drpCountry" class="col-sm-2">Country</label>
                            <div class="col-sm-4">
                               <select class="form-control" id="drpCountry">
                                   <option>Select Country</option>
                               </select>
                            </div>
                             <label for="drpState" class="col-sm-2">State</label>
                            <div class="col-sm-4">
                               <select class="form-control" id="drpState">
                                   <option>Select State</option>
                               </select>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="drpCity" class="col-sm-2">City</label>
                            <div class="col-sm-4">
                               <select class="form-control" id="drpCity">
                                   <option>Select City</option>
                               </select>
                            </div>
                             <label for="txtPin" class="col-sm-2">Pin</label>
                            <div class="col-sm-4">
                                <input type="number" class="form-control" name="txtPin" id="txtPin" />
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="txtMobile" class="col-sm-2">Mobile</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtMobile" id="txtMobile" placeholder="Mobile" title="enter your Mobile Number.">
                            </div>
                             <label for="txtPhone" class="col-sm-2">Phone</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtPhone" id="txtPhone" placeholder="Phone" title="enter your Phone Number." />
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="txtEmail" class="col-sm-2">Email</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtMobile" id="txtEmail" placeholder="Email" title="enter your Email.">
                            </div>
                             <label for="txtReferenceNo" class="col-sm-2">Reference No</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtReferenceNo" id="txtReferenceNo" placeholder="Reference Number" title="Enter Reference Number." />
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="txtPANNo" class="col-sm-2">PAN No</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtPANNo" id="txtPANNo" placeholder="PAN No" title="enter your PAN No.">
                            </div>
                             <label for="txtAnnDate" class="col-sm-2">Ann Date</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtAnnDate" id="txtAnnDate" placeholder="Ann Date" title="Enter Ann Date." />
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="txtRemarks" class="col-sm-2">Remarks</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtRemarks" id="txtRemarks" placeholder="Remarks" title="enter Remarks.">
                            </div>
                             <label for="txtCustomerCardNo" class="col-sm-2">Customer Card No</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" name="txtCustomerCardNo" id="txtCustomerCardNo" placeholder="Customer Card No" title="Enter Customer Card No." />
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="drpSRName" class="col-sm-2">SR Name</label>
                            <div class="col-sm-4">
                               <select class="form-control" id="drpSRName">
                                   <option>Select SR Name</option>
                               </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-xs-6">
                                <br />
                                <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Save</button>
                            </div>
                        </div>
                    </div>
                    

                </div>
                <!--/tab-pane-->
                <div class="tab-pane" id="loyaltyTab">
                    
                    <div class="form-group">
                        <div class="col-xs-6">
                            <br />
                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Save</button>
                        </div>
                    </div>
                </div>

                <div class="tab-pane" id="customerAndBranchTab">
                   <div class="form-group">
                        <div class="col-xs-6 pull-right">
                            <br />
                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Retrieve</button>
                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Share In Branch Group</button>
                        </div>
                    </div>
                    <div class="form-group">
                        <br />
                      <table class="table">
                          <thead>
                              <tr>
                                  <th><input type="checkbox" class="checkbox" name="chkAllBranch" id="chkAllBranch" /></th>
                                  <th>Company</th>
                                  <th>Branch</th>
                                  <th>&nbsp;</th>
                                  <th>&nbsp;</th>
                              </tr>
                          </thead>
                          <tbody>
                              <tr>
                                  <td><input type="checkbox" class="checkbox" name="chkBranch1" id="chkBranch1" /></td> 
                                  <td>Company 1</td>
                                  <td>Branch 1</td>
                                  <td>0.00 N</td>
                                  <td>CB</td>
                              </tr>
                              <tr>
                                  <td><input type="checkbox" class="checkbox" name="chkBranch2" id="chkBranch2" /></td> 
                                  <td>Company 2</td>
                                  <td>Branch 2</td>
                                  <td>0.00 N</td>
                                  <td>CB</td>
                              </tr>
                          </tbody>
                      </table>
                    </div>
                </div>

                <div class="tab-pane" id="cardPrintTab">
                    <hr>
                    <div class="form-group">
                        <div class="col-xs-6">
                            <br />
                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>Print Card</button>
                        </div>
                    </div>
                </div>

                <div class="tab-pane" id="supplierTab">
                    <hr>
                    <div class="form-group">
                        <div class="col-xs-6">
                            <br />
                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>Save</button>
                        </div>
                    </div>
                </div>

            </div>
            <!--/tab-pane-->
          </div><!--/tab-content-->

        </div><!--/col-9-->
    </div><!--/row-->
</asp:Content>
