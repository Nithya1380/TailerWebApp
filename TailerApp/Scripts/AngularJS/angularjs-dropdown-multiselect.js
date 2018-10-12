/// <reference path="angular.min.js" />

var Angular_MultiselectDropdown =
    angular.module('angular_MultiselectDropdown', []);

Angular_MultiselectDropdown.directive('dropdownMultiselect', function ($document) {
    return {
        restrict: 'E',
        scope: {
            model: '=',
            options: '=',
            extraSettings: '=',
            width: '=?',
            
        },
        replace: true,
        template:
                "<div class='web_txtbox form-control multiselect-parent btn-group dropdown-multiselect' ng-disabled='extraSettings.IsDisabled' ng-style='myStyle' data-ng-class='{open: open}'>" +
                   "<div data-ng-click='openDropdown($event)' class='RadComboBox RadComboBox_Vista kantime_drop_down' style='width: 100%;padding:0px; margin:0px;'><input type='text' ng-model='SelectVal' ng-disabled='extraSettings.IsDisabled' placeholder='--Select--' style='width: 90%;border-style: none;outline:none; padding:3px;' />" +
                    "<a class='btn btn-small' data-toggle='dropdown' data-ng-click='openDropdown($event)' style='display: inline-block; position:absolute; padding:10px 0px 0px 0px; margin:0px;'> <span class='caret'></span></a>" +
                    "</div>" +
                    "<ul class='dropdown-menu' aria-labelledby='dropdownMenu' style='width: 100%;min-height:100px;min-width:100px;max-height:300px;Overflow:auto '>" +
                        "<li style='padding-left: 5px;' ><input type='checkbox' ng-model='CheckAll ' data-ng-click='selectAll()'/> All</li>" +
                        "<li style='padding-left: 5px;' data-ng-repeat='option in options'><input type='checkbox' ng-model='option.Checked' ng-disabled='option.disabled' data-ng-click='toggleSelectItem(option)' > {{option.name}}</li>" +
                    "</ul>" +
                "</div>",
        controller: function ($scope) {
            var $dropdownTrigger;
            //$scope.extraSettings = {
            //    IsDisabled: false,
            //    OptionID: "id",
            //    OptionVal: "name",
            //    AllIDsReq: true,
            //    CheckAll: false,
            //};

            $scope.SelectVal = 'All';
            $scope.CheckAll = true;

            if ($scope.width == undefined)
                $scope.width = 180;

            $scope.myStyle = {
                "width": $scope.width + "px",
                "padding": "0px 0px 0px 0px"
            };

            //angular.element(document).ready(function () {
            //    setTimeout(function () { 
            //        GetSeletedOptions();
            //    }, 1000);
            //});
         

            $scope.openDropdown = function (event) {
                if ($scope.extraSettings != undefined )
                    if ($scope.extraSettings.IsDisabled)
                        return false;

                $scope.open = !$scope.open;
                event.stopPropagation();
                $dropdownTrigger = event.target.parentElement.parentElement; 
            };

            angular.extend($scope.options, {
                SetSeletedOptions: function (val) {
                    SetSeletedOptions(val);
                }
            });

            function SetSeletedOptions(val) {
                $scope.model = "";
                var CheckOptions = "All";
                var SelectedIds = "";
                if ($scope.options == undefined)
                    return false;
                if (($scope.options[0].id == undefined || $scope.options[0].name == undefined) && $scope.extraSettings != undefined && $scope.extraSettings.OptionID != undefined && $scope.extraSettings.OptionVal != undefined) {
                    angular.forEach($scope.options, function (item, index) {
                        $scope.options[index].id = $scope.options[index][$scope.extraSettings.OptionID];
                        $scope.options[index].name = $scope.options[index][$scope.extraSettings.OptionVal];
                    });
                }

                if (val == "") {
                    angular.forEach($scope.options, function (item, index) {
                        $scope.options[index].Checked = true;
                    });
                    $scope.CheckAll = true;
                    $scope.SelectVal = CheckOptions;
                    $scope.AllCheckkedValue = "1";
                }
                else if (val == "All") {
                    CheckOptions = "";
                    angular.forEach($scope.options, function (item, index) {
                        $scope.options[index].Checked = true;
                        CheckOptions = CheckOptions + item.name + ',';
                        SelectedIds = SelectedIds + item.id + ',';
                    });
                    $scope.CheckAll = true;
                    $scope.SelectVal = 'All';
                    $scope.model = SelectedIds;

                }
                else {

                    val = '' + val + '';
                    CheckOptions = "";
                    var AllChecked = "1";
                    var SplitItems = val.split(',');
                    var IsIDMatched = false;

                    angular.forEach($scope.options, function (item, index) {
                        IsIDMatched = false;
                        angular.forEach(SplitItems, function (valitem, valindex) {

                            if (valitem == item.id && valitem != "") {
                                IsIDMatched = true;
                                $scope.options[index].Checked = true;
                                CheckOptions = CheckOptions + item.name + ',';
                                SelectedIds = SelectedIds + item.id + ',';
                            }
                            else if (!IsIDMatched) {
                                $scope.options[index].Checked = false;
                                //AllChecked = "0";
                            }

                            if (IsIDMatched == true) {
                                return false;
                            }

                        });

                        if ($scope.options[index].Checked == false) {
                            AllChecked = "0";
                        }

                    });

                    $scope.CheckAll = false;
                    if (AllChecked == "1") {
                        $scope.CheckAll = true;
                        $scope.SelectVal = "All";
                    }
                    else {
                        $scope.SelectVal = CheckOptions;
                        $scope.model = SelectedIds;
                    }
                }

            }

            $scope.isSelected = function (id) {
                var isSelected = false;
                angular.forEach($scope.model, function (item, index) {
                    if (item == id) {
                        isSelected = true;
                    }
                });
                return isSelected;
            }

            $scope.selectAll = function () {
                $scope.model = "";
                var modelids = "";
                var CheckOptions = "";
                var isAtleastOneRecordDisabled = false;
                angular.forEach($scope.options, function (item, index) {
                    if (!item.disabled) {
                        $scope.options[index].Checked = $scope.CheckAll;
                        if ($scope.CheckAll) {
                            modelids = modelids + $scope.options[index].id + ',';
                        }
                    }
                    else
                    {
                        if ($scope.CheckAll) {
                            modelids = modelids + $scope.options[index].id + ',';
                        }
                        else
                        {
                            if ($scope.options[index].Checked) {
                                modelids = modelids + $scope.options[index].id + ',';
                                CheckOptions = CheckOptions + item.name + ',';
                                isAtleastOneRecordDisabled = true;
                            }  
                        }
                    }
                });

                if ($scope.CheckAll) {
                    $scope.SelectVal = "All"
                    if ($scope.extraSettings.AllIDsReq)
                        $scope.model = modelids;
                    else
                        $scope.model = "";
                
                } else {
                    if (isAtleastOneRecordDisabled==true)
                        $scope.model = modelids;
                    else
                        $scope.model = "-1";
                    $scope.SelectVal = CheckOptions;
                
                }

            };

            $scope.toggleSelectItem = function (option) {

                var CheckAll = true;
                var CheckVal = "";
                var CheckOptions = "";

                angular.forEach($scope.options, function (item, index) {
                    if (item.Checked) {
                        CheckVal = CheckVal + item.id + ",";
                        CheckOptions = CheckOptions + item.name + ","
                    } else {
                        CheckAll = false;
                    }
                });

                if (CheckAll) {
                    $scope.CheckAll = true;
                    $scope.model = "";
                    $scope.SelectVal = "All"
                } else if (CheckVal == "") {
                    $scope.model = "-1";
                    $scope.CheckAll = false;
                    $scope.SelectVal = "";
                } else {
                    $scope.SelectVal = CheckOptions;
                    $scope.model = CheckVal;
                    $scope.CheckAll = false;
                }

            };
            $scope.$watch($scope.options, function () {
                var CheckAll = true;
                var CheckVal = "";
                var CheckOptions = "";

                angular.forEach($scope.options, function (item, index) {
                    if (item.Checked) {
                        CheckVal = CheckVal + item.id + ",";
                        CheckOptions = CheckOptions + item.name + ","
                    } else {
                        CheckAll = false;
                    }
                });
                if (CheckAll) {
                    $scope.CheckAll = true;
                    $scope.model = "";
                    $scope.SelectVal = "All"
                } else if (CheckVal == "") {
                    $scope.model = "-1";
                    $scope.CheckAll = false;
                    $scope.SelectVal = "";
                } else {
                    $scope.SelectVal = CheckOptions;
                    $scope.model = CheckVal;
                    $scope.CheckAll = false;
                }
            });

            $document.on('click', function (e) {
                if ($scope.open) {
                    var target = e.target.parentElement;
                    var parentFound = false;

                    while (angular.isDefined(target) && target !== null && !parentFound) {
                        if (!!target.className.split && contains(target.className.split(' '), 'multiselect-parent') && !parentFound) {
                            if (target === $dropdownTrigger) {
                                parentFound = true;
                            }
                        }
                        target = target.parentElement;
                    }

                    if (!parentFound) {
                        $scope.$apply(function () {
                            $scope.open = false;
                        });
                    }
                }

            });

            function contains(collection, target) {
                var containsTarget = false;
                collection.some(function (object) {
                    if (object === target) {
                        containsTarget = true;
                        return true;
                    }
                    return false;
                });
                return containsTarget;
            }

        }
    }
});