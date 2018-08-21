<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccountMaster.aspx.cs" Inherits="TailerApp.UI.Tailer.AccountMaster" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet">
    <div class="row">
  		<div class="col-sm-10"><h1>Company Name</h1></div>
    </div>
    <div class="row">
  		<div class="col-sm-3"><!--left col-->
              
      <div class="text-center">
        <img src="http://ssl.gstatic.com/accounts/ui/avatar_2x.png" class="avatar img-circle img-thumbnail" alt="avatar">
        <h6>Upload a different photo...</h6>
        <input type="file" class="text-center center-block file-upload">
      </div><br>
         
          
        </div><!--/col-3-->
    	<div class="col-sm-9">
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
                <hr>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="first_name"><h4>Account Code</h4></label>
                              <input type="text" class="form-control" name="first_name" id="txtAccountCode" placeholder="Account Code" title="enter your Account Code.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="last_name"><h4>Account Name</h4></label>
                              <input type="text" class="form-control" name="last_name" id="last_name" placeholder="Account Name" title="enter your Account Name.">
                          </div>
                      </div>
          
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="phone"><h4>Account Type</h4></label>
                              <select class="form-control">
                                  <option>Select Account Type</option>
                              </select>
                          </div>
                      </div>
                       <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="phone"><h4>Parent Group</h4></label>
                              <select class="form-control">
                                  <option>Select Parent Group</option>
                              </select>
                          </div>
                      </div>
          
                       <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="phone"><h4>Category</h4></label>
                              <select class="form-control">
                                  <option>Select Category</option>
                              </select>
                          </div>
                      </div>
                       <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="last_name"><h4>Party Alert</h4></label>
                              <input type="text" class="form-control" name="last_name" id="last_name" placeholder="Party Alert" />
                          </div>
                      </div>

                      <div class="form-group">
                          <div class="col-xs-6">
                             <label for="mobile"><h4>Opening</h4></label>
                              <input type="text" class="form-control" name="mobile" id="mobile" placeholder="Enter opening balance" >
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="email"><h4>Closing</h4></label>
                              <input type="email" class="form-control" name="email" id="email" placeholder="Closing balance" >
                          </div>
                      </div>
                    
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="last_name"><h4>Created Date</h4></label>
                              <input type="text" class="form-control" name="last_name" id="last_name" placeholder="Created Date" />
                          </div>
                      </div>

                       <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="phone"><h4>Date</h4></label>
                              <select class="form-control">
                                  <option>Select Category</option>
                              </select>
                          </div>
                      </div>

                     <%-- <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="last_name"><h4>TDS</h4></label>
                              <input type="checkbox" class="checkbox" name="last_name" id="last_name"  />TDS Applicable
                          </div>
                      </div>

                       <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="last_name"><h4>Category</h4></label>
                              <input type="text" class="form-control" name="last_name" id="last_name" placeholder="Category" />
                          </div>
                      </div>--%>

                      <div class="form-group">
                           <div class="col-xs-6">
                               <br />
                              	<button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i> Save</button>
                            </div>
                      </div>
              <hr>
              
             </div><!--/tab-pane-->
             <div class="tab-pane" id="customerTab">
               <h2></h2>
               <hr>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="first_name"><h4>First name</h4></label>
                              <input type="text" class="form-control" name="first_name" id="first_name" placeholder="first name" title="enter your first name if any.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="last_name"><h4>Last name</h4></label>
                              <input type="text" class="form-control" name="last_name" id="last_name" placeholder="last name" title="enter your last name if any.">
                          </div>
                      </div>
          
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="phone"><h4>Phone</h4></label>
                              <input type="text" class="form-control" name="phone" id="phone" placeholder="enter phone" title="enter your phone number if any.">
                          </div>
                      </div>
          
                      <div class="form-group">
                          <div class="col-xs-6">
                             <label for="mobile"><h4>Mobile</h4></label>
                              <input type="text" class="form-control" name="mobile" id="mobile" placeholder="enter mobile number" title="enter your mobile number if any.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="email"><h4>Email</h4></label>
                              <input type="email" class="form-control" name="email" id="email" placeholder="you@email.com" title="enter your email.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="email"><h4>Location</h4></label>
                              <input type="email" class="form-control" id="location" placeholder="somewhere" title="enter a location">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="password"><h4>Password</h4></label>
                              <input type="password" class="form-control" name="password" id="password" placeholder="password" title="enter your password.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="password2"><h4>Verify</h4></label>
                              <input type="password" class="form-control" name="password2" id="password2" placeholder="password2" title="enter your password2.">
                          </div>
                      </div>
                      <div class="form-group">
                           <div class="col-xs-6">
                               <br />
                              	<button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i> Save</button>
                            </div>
                      </div>
  
             </div><!--/tab-pane-->
             <div class="tab-pane" id="loyaltyTab">
                <hr>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="first_name"><h4>First name</h4></label>
                              <input type="text" class="form-control" name="first_name" id="first_name" placeholder="first name" title="enter your first name if any.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="last_name"><h4>Last name</h4></label>
                              <input type="text" class="form-control" name="last_name" id="last_name" placeholder="last name" title="enter your last name if any.">
                          </div>
                      </div>
          
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="phone"><h4>Phone</h4></label>
                              <input type="text" class="form-control" name="phone" id="phone" placeholder="enter phone" title="enter your phone number if any.">
                          </div>
                      </div>
          
                      <div class="form-group">
                          <div class="col-xs-6">
                             <label for="mobile"><h4>Mobile</h4></label>
                              <input type="text" class="form-control" name="mobile" id="mobile" placeholder="enter mobile number" title="enter your mobile number if any.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="email"><h4>Email</h4></label>
                              <input type="email" class="form-control" name="email" id="email" placeholder="you@email.com" title="enter your email.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="email"><h4>Location</h4></label>
                              <input type="email" class="form-control" id="location" placeholder="somewhere" title="enter a location">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                              <label for="password"><h4>Password</h4></label>
                              <input type="password" class="form-control" name="password" id="password" placeholder="password" title="enter your password.">
                          </div>
                      </div>
                      <div class="form-group">
                          
                          <div class="col-xs-6">
                            <label for="password2"><h4>Verify</h4></label>
                              <input type="password" class="form-control" name="password2" id="password2" placeholder="password2" title="enter your password2.">
                          </div>
                      </div>
                      <div class="form-group">
                           <div class="col-xs-6">
                               <br />
                              	<button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i> Save</button>
                            </div>
                      </div>
              </div>

                <div class="tab-pane" id="customerAndBranchTab">
                <hr>
                    <div class="form-group">
                           <div class="col-xs-6">
                               <br />
                              	<button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i> Save</button>
                            </div>
                      </div>
                </div>

              <div class="tab-pane" id="cardPrintTab">
                <hr>
                  <div class="form-group">
                           <div class="col-xs-6">
                               <br />
                              	<button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i> Save</button>
                            </div>
                      </div>
              </div>

              <div class="tab-pane" id="supplierTab">
                <hr>
                  <div class="form-group">
                           <div class="col-xs-6">
                               <br />
                              	<button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i> Save</button>
                            </div>
                      </div>
              </div>
               
              </div><!--/tab-pane-->
          </div><!--/tab-content-->

        </div><!--/col-9-->
    </div><!--/row-->
</asp:Content>
