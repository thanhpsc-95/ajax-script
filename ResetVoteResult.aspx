<%@ Page Title="" Language="C#" MasterPageFile="~/Systems/MasterPage.Master" AutoEventWireup="true" CodeBehind="ResetVoteResult.aspx.cs" Inherits="PSCPortal.Systems.Statistic.ResetVoteResult" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Lib datatables,semantic ui--%>
    <link href="/Scripts/datatables/css/semantic.min.css" rel="stylesheet" />
    <link href="/Scripts/datatables/css/dataTables.semanticui.min.css" rel="stylesheet" />
    <link href="/Scripts/datatables/css/buttons.semanticui.min.css" rel="stylesheet" />
    <link href="/Scripts/datatables/css/select.dataTables.min.css" rel="stylesheet" />
    <link href="/Scripts/datatables/css/fixedHeader.dataTables.css" rel="stylesheet" />
    <link href="/Scripts/datatables/css/scroller.dataTables.min.css" rel="stylesheet" />
    <link href="/Scripts/datatables/css/keyTable.dataTables.min.css" rel="stylesheet" />

    <link href="/Scripts/alertifyjs/css/alertify.min.css" rel="stylesheet" />

    <script type="text/javascript" src="/Scripts/datatables/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/semantic.min.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/dataTables.semanticui.min.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/dataTables.buttons.min.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/buttons.semanticui.min.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/dataTables.select.min.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/dataTables.fixedHeader.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/dataTables.scroller.min.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/dataTables.keyTable.min.js"></script>
    <script type="text/javascript" src="/Scripts/datatables/js/dataTables.pipeline.js"></script>

    <script type="text/javascript" src="/Scripts/alertifyjs/js/alertify.min.js"></script>

    <script type="text/javascript" src="/Scripts/datatables/js/moment-with-locales.js"></script>
    <script type="text/javascript">
        //override defaults
        alertify.defaults.transition = "zoom";
        alertify.defaults.theme.ok = "ui positive button";
        alertify.defaults.theme.cancel = "ui black button";
    </script>
    <%--Lib datatables,alertify,semantic ui--%>
    <style type="text/css">
        .tieudetimkiem {
            width: 692px;
            background-color: #5270AF;
            clear: both;
            float: left;
            text-align: center;
            color: #fff;
            font-size: 18px;
            font-family: Arial;
            height: 40px;
            font-weight: bold;
            padding-top: 10px;
        }

        .khung_tracuu {
            /*width: 670px;*/
            width: 692px;
            float: left;
            padding: 10px;
            font-family: Arial;
            font-size: 12px;
            color: #000;
            border: 1px solid #817F7F;
        }

            .khung_tracuu .dongtimkiem {
                width: 600px;
                float: left;
                clear: both;
                padding: 5px 0px 5px 0px;
            }

                .khung_tracuu .dongtimkiem span {
                    font-weight: bold;
                    width: 190px;
                    float: left;
                    padding-right: 10px;
                    text-align: right;
                    margin-top: 3px;
                }

        .chondotdanhgia {
            float: left;
            padding-right: 10px;
            text-align: right;
            margin-top: 5px;
            max-width: 100%;
        }

        .khung_tracuu .timkiem {
            width: 600px;
            clear: both;
            float: left;
            text-align: center;
        }
        /*table result report*/
        .tbcontainer {
            clear: both;
            float: left;
            width: 970px;
            font-family: Arial;
            font-size: 13px;
            color: #00156e;
        }

        .trHeader {
            font-weight: bold;
            font-family: Arial;
            font-size: 13px;
            color: #00156e;
            background-color: #d1e0f3;
            width: 600px;
        }

        .Field {
            width: 250px;
            text-align: justify;
            border: 1px solid #0084bb;
            border-left: 0px;
            border-top: 0px;
        }

        .tdColumn {
            border-right: 1px solid #817F7F;
            border-bottom: 1px solid #817F7F;
            text-align: center;
            border-left-style: none;
            border-left-color: inherit;
            border-left-width: 0px;
            border-top-style: none;
            border-top-color: inherit;
            border-top-width: 0px;
        }

        .tdColumnQuanlity {
            width: 50px;
            text-align: center;
            border: 1px solid #817F7F;
            border-left: 0px;
            border-top: 0px;
        }

        .tdColumnPercent {
            width: 50px;
            text-align: center;
            border: 1px solid #817F7F;
            border-left: 0px;
            border-top: 0px;
        }

        .trFooter {
            font-weight: bold;
            font-family: Arial;
            font-size: 13px;
            color: #00156e;
            background-color: #817F7F;
        }

        .statisticTable {
            border-color: #817F7F;
            width: 810px;
            border-style: solid;
            background-color: white;
            width: 100%;
            border-collapse: collapse;
        }

            .statisticTable th {
                text-align: center;
            }

        .alertify-notifier {
            color: white;
            font-family: Arial, Helvetica, sans-serif;
        }

        table.dataTable tbody > tr:hover {
            background-color: rgba(84, 200, 255,0.2);
        }

        table.dataTable tbody > tr.selected {
            font-weight: bold;
            background-color: rgba(84, 200, 255,1);
        }

        .dataTables_info {
            font-style: italic;
            font-size: small;
        }
    </style>
    <script type="text/javascript" language="javascript">
        var viewModel = null;
        var results = {};
        var toDay = new Date();
        var ObjKOut = function (items) {
            var self = this;
            self.TestArray = [];
            self.voteGrid = ko.observable(
                { Statistic_RatingTemplateDTOs: ko.observableArray([]), Name: '', TotalVote: ko.observable(), TotalAnswerCount: ko.observable(), TotalStudents: ko.observable(), TotalVotedStudents: ko.observable() }
            );
            self.cbbxClass = ko.observableArray(items);
            self.VoteFormId = 'C31AD83E-AFBE-4765-A006-AA14430B41D6';
            self.class_Selected = ko.observable();
            self.VoteUserList = ko.observableArray();
            self.cbbxCourse = ko.observableArray([]);
            self.course_Selected = ko.observable();
            self.LoaiThongKe = ko.observable('0');
            self.ThongKeTheo = ko.observable('0');
            self.UserId = '';
            self.DepartmentId = ko.observable("-1");
            self.OlogyList = ko.observableArray([]);
            self.OlogyId = "-1";
            self.DepartmentList = [];
            self.StudyYears = [];
            self.VoteForms = ko.observable();
            self.GraduatedQuestionId = '12366FAA-9D75-4B64-8C6B-683254ED5267';
            self.Thoigian = ko.observable(false);

            self.DepartmentId.subscribe(function (newData) {
                self.LoadOlogyList();
            });


            self.LoadOlogyList = function (newData) {
                if (self.DepartmentId && self.class_Selected()) {
                    $.ajax({
                        url: "<%=CurrentPagePath%>/GetOlogyList",
                        type: 'POST',
                        async: false,
                        data: ko.toJSON({ classId: self.class_Selected(), departmentId: self.DepartmentId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: 'json',
                        success: function (data) {
                            var results = Sys.Serialization.JavaScriptSerializer.deserialize(data.d);
                            results.unshift({ Name: "Tất cả", Id: -1 });
                            self.OlogyList(results);
                        }
                    });
                }
            }

            self.StudyYearId = ko.observable("");
            self.StudyYearId.subscribe(function (newValue) {
                self.LoadVoteForm();
            });
            self.LoadStudyYear = function () {
                $.ajax({
                    url: "<%=CurrentPagePath%>/GetStudyYears",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=utf8",
                    async: false,
                    success: function (result) {
                        var data = $.parseJSON(result.d);
                        self.StudyYears = data;
                    }
                })
            }
            self.LoadStudyYear();


            self.LoadVoteForm = function () {
                if (self.class_Selected()) {
                    $.ajax({
                        url: "<%=CurrentPagePath%>/GetVoteForms",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json; charset=utf8",
                        data: ko.toJSON({ studyYearId: self.StudyYearId(), classId: self.class_Selected() }),
                        async: false,
                        success: function (result) {
                            var data = $.parseJSON(result.d);
                            self.VoteForms(data);
                        }
                    });
                }
            }

            function getCurrentStudyYear() {
                var result = '';
                var currentDate = new Date();
                var currentYear = parseInt(currentDate.getFullYear());
                var currentMonth = parseInt(currentDate.getMonth());
                if (currentMonth >= 9)
                    result = currentYear + '-' + parseInt(currentYear + 1);
                else
                    result = parseInt(currentYear - 1) + '-' + currentYear;
                return result;
            }

            self.StudyYearId(getCurrentStudyYear());

            self.class_Selected.subscribe(function (item) {
                self.LoadVoteForm();
                self.LoadOlogyList();
            });


            self.cbbxYear = ko.observableArray();
            self.yearValue = ko.observable();
            for (var i = 0; i <= 4; i++) {
                self.cbbxYear.push(toDay.getFullYear() - i);
            }
            self.yearValue.subscribe(function () {
                self.GetWeekArray(self.yearValue());
            });



            self.totalVote = ko.computed(function () {
                var total = 0;
                //$.each(self.voteGrid(), function (i, item) {
                //    $.each(item.QuestionList, function (idx, item2) {                  
                //        if (item2.QuestionType != 2) {
                //            var arr = item2.AnswerResults;
                //            $.each(arr, function (i, item) {
                //                total += item.VotesCount;
                //            });
                //            return false;
                //        }
                //    });
                //    return false;
                //});
                return total;
            });

            self.SerchVoteUsers = function () {
                self.VoteUserList([]);

                if (self.ThongKeTheo() == 0)
                    self.DepartmentId = "-1";
                else
                    self.UserId = "";
                $.ajax({
                    url: "<%=CurrentPagePath%>/GetVotedUserList",
                    type: 'POST',
                    //async: false,
                    data: ko.toJSON({ classId: self.VoteFormId, userId: self.UserId, departmentId: self.DepartmentId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: 'json',
                    success: function (data) {
                        var results = Sys.Serialization.JavaScriptSerializer.deserialize(data.d);
                        self.VoteUserList(results.Data);
                        if (self.UserId != '') {
                            if (self.VoteUserList().length > 0)
                                alert("Sinh viên đã đánh giá");
                            else
                                alert("Chưa đánh giá");
                        }
                        else {
                            alert("Có " + self.VoteUserList().length + " sinh viên đã đánh giá");
                        }
                    }
                });
            }

            self.SearchStatistic = function () {
                var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                if (TuNgay != null && DenNgay != null) {
                    TuNgay.format("mm/dd/yyyy");
                    DenNgay.format("mm/dd/yyyy");
                    if (TuNgay > DenNgay) {
                        radalert("Từ ngày <= đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                        return;
                    }
                    else {
                        $.ajax({
                            url: "VoteStatistic.aspx/Vote_Detail",
                            type: 'POST',
                            //async: false,
                            data: ko.toJSON({ voteFormId: self.VoteFormId, departmentId: self.DepartmentId, ologyId: self.OlogyId, TuNgay: TuNgay, DenNgay: DenNgay }),
                            contentType: "application/json; charset=utf-8",
                            dataType: 'json',
                            success: function (results) {
                                var data = $.parseJSON(results.d);
                                self.voteGrid().Statistic_RatingTemplateDTOs(data.Statistic_RatingTemplateDTOs);
                                self.voteGrid().TotalVote(data.TotalVoteCount);
                                self.voteGrid().TotalAnswerCount(data.TotalAnswerCount);
                                self.voteGrid().TotalVotedStudents(data.TotalVotedStudents);
                                self.voteGrid().TotalStudents(data.TotalStudents);
                            }
                        });
                    }

                }
                else if (TuNgay == null && DenNgay != null) {
                    radalert("Nhập vào từ ngày", 250, 100, "<%= Resources.Site.Warning %>");
                    return;
                }
                else if (TuNgay != null && DenNgay == null) {
                    radalert("Nhập vào đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                    return;
                }
                else {
                    $.ajax({
                        url: "<%=CurrentPagePath%>/Vote_Details",
                        type: 'POST',
                        data: ko.toJSON({ voteFormId: self.VoteFormId, departmentId: self.DepartmentId, ologyId: self.OlogyId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: 'json',
                        success: function (results) {
                            var data = $.parseJSON(results.d);
                            self.voteGrid().Statistic_RatingTemplateDTOs(data.Statistic_RatingTemplateDTOs);
                            self.voteGrid().TotalVote(data.TotalVoteCount);
                            self.voteGrid().TotalAnswerCount(data.TotalAnswerCount);
                            self.voteGrid().TotalVotedStudents(data.TotalVotedStudents);
                            self.voteGrid().TotalStudents(data.TotalStudents);
                        }
                    });
                }
                if (self.Thoigian() == false) {
                    $.ajax({
                        url: "<%=CurrentPagePath%>/Vote_Details",
                        type: 'POST',
                        //async: false,
                        data: ko.toJSON({ voteFormId: self.VoteFormId, departmentId: self.DepartmentId, ologyId: self.OlogyId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: 'json',
                        success: function (results) {
                            var data = $.parseJSON(results.d);
                            self.voteGrid().Statistic_RatingTemplateDTOs(data.Statistic_RatingTemplateDTOs);
                            self.voteGrid().TotalVote(data.TotalVoteCount);
                            self.voteGrid().TotalAnswerCount(data.TotalAnswerCount);
                            self.voteGrid().TotalVotedStudents(data.TotalVotedStudents);
                            self.voteGrid().TotalStudents(data.TotalStudents);
                        }
                    });
                }
            }

            self.btnSearch = function () {
                var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                let params = { voteFormId: self.VoteFormId, departmentId: self.DepartmentId(), ologyId: self.OlogyId };
                if (self.VoteFormId) {
                    $('#table-result').empty();
                    let currentTable = $('#table-result').DataTable({
                        dom: "<'ui grid'" +
                            "<'row control'" +
                            "<'eight wide column'B>" +
                            "<'right aligned eight wide column'f>" +
                            ">" +
                            "<'row dt-table'" +
                            "<'sixteen wide column'tr>" +
                            ">" +
                            "<'row'" +
                            "<'six wide column'i>" +
                            "<'right aligned ten wide column'p>" +
                            ">" +
                            ">",
                        ajax: {
                            url: "/Helper/ServerHandler.ashx",
                            contentType: "application/json",
                            type: "POST",
                            pages: 5,
                            headers: {
                                contentType: "application/json"
                            },
                            dataType: "json",
                            data: function (d) {
                                d.voteFormId = params.voteFormId;
                                d.departmentId = params.departmentId;
                                d.ologyId = params.ologyId;
                                d = JSON.stringify(d);
                                return d;
                            },
                            dataSrc: function (json) {
                                return json.data;
                            }
                        },
                        stateSave: true,
                        processing: false,
                        serverSide: true,
                        scrollY: '70vh',
                        scrollX: true,
                        scrollCollapse: true,
                        fixedHeader: {
                            header: false
                        },
                        lengthMenu: [[10, 25, 50, 100, 250, 500], [10, 25, 50, 100, 250, 500]],
                        pageLength: 50,
                        columnDefs: [{
                            orderable: false,
                            searchable: false,
                            className: 'select-checkbox',
                            targets: 0,
                            checkboxes: {
                                selectRow: true
                            }
                        }],
                        select: {
                            style: 'os',
                            selector: /*'td'*/ 'td:first-child',
                            info: true
                        },
                        order: [[1, 'asc']],                        buttons: [                            {                                attr: { id: "button-delete-vote" },                                text: '<i class="ui trash alternate icon"></i> Xoá',
                                action: function (e, dt, node, config) {
                                    let row = dt.row({ selected: true });
                                    let data = row.data();
                                    $('#header-confirm-delete').empty();
                                    $('#content-confirm-delete').empty();
                                    $('<div class="ui red sub header"><i class="ui exclamation triangle icon"></i> Xác nhận xoá</div>').appendTo('#header-confirm-delete');
                                    $('<div class="ui red message"><i class="ui question circle icon"></i> Xoá kết quả phiếu khảo sát đã chọn ?</div>').appendTo('#content-confirm-delete');
                                    $('#modal').removeClass('hidden');
                                    $('.ui.modal').modal({
                                        onHide: function () {
                                            row.deselect();
                                        }
                                    }).modal('show');
                                    $('#action-cancel').click(function () {
                                        row.deselect();
                                    });
                                    $('#action-delete').off().click(function () {
                                        $.ajax({
                                            url: "<%=CurrentPagePath%>/DeleteVoteResult",
                                            type: 'POST',
                                            data: ko.toJSON({ voteResultId: data.Id }),
                                            contentType: "application/json; charset=utf-8",
                                            dataType: 'json',
                                            success: function (results) {
                                                let deleteResult = $.parseJSON(results.d);
                                                if (deleteResult == true) {
                                                    dt.ajax.reload(null, true);
                                                    alertify.success(
                                                        '<div class="notify-box">' +
                                                        '<div class="content">' +
                                                        '<i class="ui check icon"></i> Xoá thành công' +
                                                        '</div>' +
                                                        '</div >'
                                                    );
                                                } else {
                                                    alertify.error(
                                                        '<div class="notify-box">' +
                                                        '<div class="content">' +
                                                        '<i class="ui exclamation triangle icon"></i> Xoá thất bại' +
                                                        '</div>' +
                                                        '</div >'
                                                    );
                                                }
                                            },
                                            error: function (xhr, error) {
                                                alertify.error(
                                                    '<div class="notify-box">' +
                                                    '<div class="content">' +
                                                    '<i class="ui exclamation triangle icon"></i> Xoá thất bại' +
                                                    '</div>' +
                                                    '</div >'
                                                );
                                            }
                                        });
                                    });
                                }
                            }                        ],                        columns: [{
                            data: null,
                            orderable: false,
                            searchable: false,
                            className: "select-checkbox",
                            render: function () { return null }
                        },
                        { "data": "UserId", "title": "Mã SV/GV" },
                        { "data": "Name", "title": "Họ tên" },
                        { "data": "VoteObjectId", "title": "Mã học phần" },
                        {
                            "data": "VoteTime",
                            "title": "Ngày đánh giá"
                            ,
                            "render": function (data, type) {
                                if (type === "sort" || type === "type") {
                                    return data;
                                }
                                return moment(new Date(data)).locale('vi').format("L LTS");
                            }
                        }
                        ],
                        destroy: true,
                        preDrawCallback: function () {
                            $(this.api().rows().nodes()).off();
                        },
                        language: {
                            decimal: "",
                            emptyTable: "Bảng không có dữ liệu",
                            info: "Đang xem _START_ đến _END_ trong tổng số _TOTAL_ dòng",
                            infoEmpty: "Đang xem 0 đến 0 trong tổng số 0 dòng",
                            infoFiltered: "(được lọc từ _MAX_ dòng)",
                            infoPostFix: "",
                            thousands: ".",
                            lengthMenu: "Xem _MENU_ dòng",
                            loadingRecords: "Đang tải...",
                            processing: 'Đang tiến hành',
                            search: "Tìm:",
                            zeroRecords: "Không tìm thấy kết quả phù hợp",
                            paginate: {
                                first: "Đầu",
                                last: "Cuối",
                                next: "Kế",
                                previous: "Trước"
                            },
                            aria: {
                                sortAscending: ": kích hoạt sắp xếp cột tăng dần",
                                sortDescending: ": kích hoạt sắp xếp cột giảm dần"
                            },
                            select: {
                                rows: {
                                    _: "Đã chọn %d dòng",
                                    0: "Nhấn vào để chọn",
                                    1: "Đã chọn 1 dòng"
                                }
                            }
                        }
                    });
                    $("#button-delete-vote").parent().addClass("red inverted").removeClass("basic");
                    let inputSearch = $("#table-result_filter input");
                    inputSearch.off().keypress(function (event) {
                        if (event.which == '13' || event.keyCode == '13') {
                            let searchValue = inputSearch.val();
                            currentTable.search(searchValue, false).draw();
                        }
                    });
                    inputSearch.parent()
                        .attr('data-tooltip', 'Gõ từ cần tìm sau đó nhấn Enter để tìm')
                        .attr('data-position', "bottom right")
                        .attr('data-inverted', '');
                    inputSearch.parent().popup({
                        on: 'focus'
                    })
                } else {
                    alertify.error(
                        '<div class="notify-box">' +
                        '<div class="content">' +
                        '<i class="ui exclamation triangle icon"></i> Không có dữ liệu kết quả phiếu khảo sát này' +
                        '</div>' +
                        '</div >'
                    );
                }

            }

            self.printClick = function () {

                if (self.class_Selected() == undefined)
                    return;
                if (self.timerValue() != "All")
                    window.open("VoteStatistic_Print.aspx?classId=" + self.class_Selected().Id + "&className=" + self.class_Selected().Name + "&startDate=" + startDate.format("MM/dd/yyyy") + "&endDate=" + endDate.format("MM/dd/yyyy") + "&LoaiThongKe=" + self.LoaiThongKe() + "&thongketheo" + self.ThongKeTheo() + "&departmentId=" + self.DepartmentId + "&userid=" + self.UserId + "&totalVote=" + self.totalVote() + "&type=1", "", "status=0,toolbar=0,width=1000,height=900");
                else
                    window.open("VoteStatistic_Print.aspx?classId=" + self.class_Selected().Id + "&className=" + self.class_Selected().Name + "&startDate=" + startDate.format("MM/dd/yyyy") + "&endDate=" + endDate.format("MM/dd/yyyy") + "&LoaiThongKe=" + self.LoaiThongKe() + "&thongketheo" + self.ThongKeTheo() + "&departmentId=" + self.DepartmentId + + "&userid=" + self.UserId + "&totalVote=" + self.totalVote() + "&type=0", "", "status=0,toolbar=0,width=1000,height=900");
            }

            self.excelExport = function () {
                if (self.class_Selected() == undefined || self.VoteFormId == undefined)
                    return;
                else {
                    if (self.Thoigian() == true) {
                        var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                        var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                        if (TuNgay != null && DenNgay != null) {
                            if (TuNgay > DenNgay) {
                                radalert("Từ ngày <= đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                                return;
                            }
                            else
                                window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId + "&option=3" + "&TuNgay=" + TuNgay.format("dd/MM/yyyy") + "&DenNgay=" + DenNgay.format("dd/MM/yyyy"));
                        }
                        else if (TuNgay == null && DenNgay != null) {
                            radalert("Nhập vào từ ngày", 250, 100, "<%= Resources.Site.Warning %>");
                            return;
                        }
                        else if (TuNgay != null && DenNgay == null) {
                            radalert("Nhập vào đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                            return;
                        }
                        else
                            window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId + "&option=3");
                    }
                    else if (self.Thoigian() == false)
                        window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId + "&option=3");
                }
            }

            self.excelExportStatistic = function () {

                if (self.class_Selected() == undefined)
                    return;
                if (self.timerValue() != "All")
                    window.open("/Services/ExportToExcel.ashx?classId=" + self.class_Selected().Id + "&className=" + self.class_Selected().Name + "&startDate=" + startDate.format("MM/dd/yyyy") + "&endDate=" + endDate.format("MM/dd/yyyy") + "&option=0&totalVote=" + self.totalVote() + "&departmentId=" + self.DepartmentId + "&type=1");
                else
                    window.open("/Services/ExportToExcel.ashx?classId=" + self.class_Selected().Id + "&className=" + self.class_Selected().Name + "&startDate=" + startDate.format("MM/dd/yyyy") + "&endDate=" + endDate.format("MM/dd/yyyy") + "&option=0&totalVote=" + self.totalVote() + "&departmentId=" + self.DepartmentId + "&type=0");
            }

            self.excelExportTextAnswer = function () {

                if (self.class_Selected() == undefined)
                    return;
                if (self.timerValue() != "All")
                    window.open("/Services/ExportToExcel.ashx?classId=" + self.class_Selected().Id + "&className=" + self.class_Selected().Name + "&startDate=" + startDate.format("MM/dd/yyyy") + "&endDate=" + endDate.format("MM/dd/yyyy") + "&option=7&totalVote=" + self.totalVote() + "&departmentId=" + self.DepartmentId + "&type=1");
                else
                    window.open("/Services/ExportToExcel.ashx?classId=" + self.class_Selected().Id + "&className=" + self.class_Selected().Name + "&startDate=" + startDate.format("MM/dd/yyyy") + "&endDate=" + endDate.format("MM/dd/yyyy") + "&option=7&totalVote=" + self.totalVote() + "&departmentId=" + self.DepartmentId + "&type=0");
            }

            self.excelExportUserList = function () {
                var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                //if (self.class_Selected() == undefined)
                //    return;
                //if (self.ThongKeTheo() == 0)
                //    self.DepartmentId = "";
                //else
                //    self.UserId = "";
                if (self.class_Selected() == undefined || self.VoteFormId == undefined)
                    return;
                else if (self.class_Selected() == "10") {
                    if (self.Thoigian() == true) {
                        if (TuNgay != null && DenNgay != null) {
                            if (TuNgay > DenNgay) {
                                radalert("Từ ngày <= đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                                return;
                            }
                            else
                                window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=6&userId=" + self.UserId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId + "&TuNgay=" + TuNgay.format("dd/MM/yyyy") + "&DenNgay=" + DenNgay.format("dd/MM/yyyy"));
                        }
                        else if (TuNgay == null && DenNgay != null) {
                            radalert("Nhập vào từ ngày", 250, 100, "<%= Resources.Site.Warning %>");
                            return;
                        }
                        else if (TuNgay != null && DenNgay == null) {
                            radalert("Nhập vào đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                            return;
                        }
                        else
                            window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=6&userId=" + self.UserId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId);
                    }
                    else if (self.Thoigian() == false)
                        window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=6&userId=" + self.UserId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId);
                }
                else {
                    if (self.Thoigian() == true) {
                        if (TuNgay != null && DenNgay != null) {
                            if (TuNgay > DenNgay) {
                                radalert("Từ ngày <= đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                                return;
                            }
                            else
                                window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=4&userId=" + self.UserId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId + "&TuNgay=" + TuNgay.format("dd/MM/yyyy") + "&DenNgay=" + DenNgay.format("dd/MM/yyyy"));
                        }
                        else if (TuNgay == null && DenNgay != null) {
                            radalert("Nhập vào từ ngày", 250, 100, "<%= Resources.Site.Warning %>");
                            return;
                        }
                        else if (TuNgay != null && DenNgay == null) {
                            radalert("Nhập vào đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                            return;
                        }
                        else
                            window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=4&userId=" + self.UserId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId);
                    }
                    else if (self.Thoigian() == false) {
                        window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=4&userId=" + self.UserId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId);
                    }
                }
            }

            self.GetTextAnswerByQuestion = function (item) {
                var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                if (TuNgay != null && DenNgay != null) {
                    window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&QuestionId=" + item.Id + "&option=1" + "&TuNgay=" + TuNgay.format("dd/MM/yyyy") + "&DenNgay=" + DenNgay.format("dd/MM/yyyy"));
                }
                else
                    window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&QuestionId=" + item.Id + "&option=1");
            }

            self.GetTextAnswerByAnswer = function (item) {
                var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                if (TuNgay != null && DenNgay != null) {
                    window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&AnswerId=" + item.OldId + "&option=2" + "&TuNgay=" + TuNgay.format("dd/MM/yyyy") + "&DenNgay=" + DenNgay.format("dd/MM/yyyy"));
                }
                else
                    window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&AnswerId=" + item.OldId + "&option=2");
            }

            self.excelExportResultByEachUser = function () {
                var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                if (self.class_Selected() == undefined || self.VoteFormId == undefined)
                    return;
                else if (TuNgay != null && DenNgay != null) {
                    window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=5" + "&TuNgay=" + TuNgay.format("dd/MM/yyyy") + "&DenNgay=" + DenNgay.format("dd/MM/yyyy"));
                }
                else
                    window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=5");
            }

            self.excelExportAnswerByUser = function () {
                var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                if (self.class_Selected() == undefined || self.VoteFormId == undefined)
                    return;
                else {
                    if (self.DepartmentId() == '-1') {
                        alert('Vui lòng chọn cụ thể 1 đơn vị!');
                        return;
                    }
                    else {
                        if (TuNgay != null && DenNgay != null) {
                            if (TuNgay > DenNgay) {
                                radalert("Từ ngày <= đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                                return;
                            }
                            else
                                window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=7&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId + "&TuNgay=" + TuNgay.format("dd/MM/yyyy") + "&DenNgay=" + DenNgay.format("dd/MM/yyyy"));
                        }
                        else if (TuNgay == null && DenNgay != null) {
                            radalert("Nhập vào từ ngày", 250, 100, "<%= Resources.Site.Warning %>");
                            return;
                        }
                        else if (TuNgay != null && DenNgay == null) {
                            radalert("Nhập vào đến ngày", 250, 100, "<%= Resources.Site.Warning %>");
                            return;
                        }
                        else
                            window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&option=7&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId);
                    }
                }
            }

            self.keypress = function (sender, event) {
                if (event.charCode == 13) {
                    this.btnSearch();
                }
                return true;
            };
            self.excelExportData = function () {
                var TuNgay = $find("<%=rdtStartTime.ClientID %>").get_selectedDate();
                var DenNgay = $find("<%=rdtEndTime.ClientID %>").get_selectedDate();
                if (self.class_Selected() == undefined || self.VoteFormId == undefined)
                    return;
                else {
                    window.open("/Systems/Statistic/ExcelExport/ExportToExcel.ashx?voteFormId=" + self.VoteFormId + "&departmentId=" + self.DepartmentId() + "&ologyId=" + self.OlogyId + "&option=7");
                }
            }


            $.ajax({
                url: "<%=CurrentPagePath%>/GetDepartmentList",
                type: 'POST',
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                success: function (data) {
                    var results = Sys.Serialization.JavaScriptSerializer.deserialize(data.d);
                    self.DepartmentList = results;
                    self.DepartmentList.unshift({ Name: "Toàn trường", Id: -1 });
                }
            });
        }

        $(function () {
            $(document).ajaxStart(function () {
                // $("#loading").show();
                $("#imgLoading").show();
                $("#btnTim").attr("disabled", "disabled");
            });
            $(document).ajaxStop(function () {
                // $("#loading").show();
                $("#imgLoading").hide();
                $("#btnTim").removeAttr("disabled");
            });
            $.ajax({
                url: "<%=CurrentPagePath%>/GetListClass",
                type: 'POST',
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                success: function (data) {
                    results = Sys.Serialization.JavaScriptSerializer.deserialize(data.d);
                }
            });
            var viewModel = new ObjKOut(results);
            ko.applyBindings(viewModel, $get("VoteStatistic_Form"));
            $('select').change(function () {
                this.title = $(this).children('option:selected').text();
            }).change();
            $("#table-wrapper").css({
                "font-family": "Arial ",
                "font-size": "12px"
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="VoteStatistic_Form">
        <div style="width: 620px; padding-left: 110px;">
            <div class="tieudetimkiem">
                <%=TitlePage.ToUpper()%>
            </div>
            <div class="khung_tracuu">
                <div class="dongtimkiem">
                    <div style="float: left; width: 600px;">
                        <span>Chọn Tiêu Chuẩn:</span>
                        <select style="float: left; display: inline; width: 300px;" data-bind='options: cbbxClass, optionsText: "Name", optionsValue: "Id", optionsCaption: "Vui lòng chọn lớp đánh giá", value: class_Selected, valueUpdate: "change"'></select>
                        <span data-bind="visible: class_Selected() == undefined " style="padding-left: 10px; text-align: left; color: red; width: 10px;">*</span>
                    </div>
                </div>

                <div class="dongtimkiem" data-bind="visible: cbbxCourse().length > 0">
                    <span>Chọn Môn học:</span>
                    <div style="float: left">
                        <select data-bind='options: cbbxCourse, optionsText: "Name", optionsCaption: "Vui lòng chọn Môn học", value: course_Selected, valueUpdate: "change"'></select>
                    </div>
                </div>
                <%--<div class="dongtimkiem">
                    <span>Loại thống kê:</span>
                    <div style="float: left">
                        <input id="radLuotDanhGia" data-bind="checked: LoaiThongKe" value="0" name="loaiThongKe" type="radio" /><label for="radLuotDanhGia">Lượt đánh giá</label>
                        <input id="radNguoiDung" data-bind="checked: LoaiThongKe" value="1" name="loaiThongKe" type="radio" /><label for="radNguoiDung">Người dùng đánh giá</label>
                    </div>
                </div>
                <div class="dongtimkiem" data-bind="visible: LoaiThongKe()==1 && ThongKeTheo()==0"">
                    <span>Mã người dùng:</span>
                    <div style="float: left">
                        <input type="text" data-bind="value: UserId , event: {keypress: keypress}"/>
                    </div>
                </div>
                <div class="dongtimkiem" data-bind="visible: LoaiThongKe()==1">
                    <span>Loại thống kê người dùng:</span>
                    <div style="float: left">
                        <input id="radMaNguoiDung"  data-bind="checked: ThongKeTheo" value="0" name="ThongKeTheo" type="radio" /><label for="radMaNguoiDung">Theo mã người dùng</label>
                        <input id="radKhoa" data-bind="checked: ThongKeTheo" value="1" name="ThongKeTheo" type="radio" /><label for="radKhoa">Theo khoa</label>
                    </div>
                </div>--%>
                <div class="dongtimkiem">
                    <div style="float: left; width: 600px;">
                        <span>Phạm vi thống kê:</span>
                        <select style="float: left; width: 150px;" data-bind='options: DepartmentList, optionsText: "Name", optionsValue: "Id", value: DepartmentId'></select>
                        <span data-bind="visible: class_Selected() == undefined " style="padding-left: 10px; text-align: left; color: red; width: 10px;">*</span>
                        <select style="width: 150px; display: inline;" data-bind='options: OlogyList, optionsText: "Name", optionsValue: "Id", value: OlogyId'></select>
                    </div>
                </div>
                <div class="dongtimkiem">
                    <div style="float: left; width: 600px;">
                        <span>Chọn đợt đánh giá: </span>
                        <select style="float: left; width: 80px;" data-bind='options: StudyYears, value: StudyYearId, optionsText: "Name", optionsValue: "Id"'></select>
                    </div>
                    <div style="clear: both; margin-left: 65px; text-overflow: ellipsis; overflow: hidden;">
                        <select data-bind='options: VoteForms, value: VoteFormId, optionsText: "Name", optionsValue: "Id"'></select>
                    </div>
                </div>
                <div class="dongtimkiem">
                    <div style="float: left; width: 600px; margin-left: 65px;">
                        <input type="checkbox" id="ckbthoigian" data-bind="checked: Thoigian" />
                        <label for="ckbthoigian">Chọn thời gian đánh giá:</label>
                    </div>
                    <div style="float: left; width: 600px; margin-left: 65px;" data-bind="visible: Thoigian">
                        <label style="margin-left: 15px; font-weight: bold">Từ ngày </label>
                        <telerik:RadDatePicker ID="rdtStartTime" runat="server" Width="140px">
                            <DateInput DateFormat="dd/MM/yyyy" runat="server" />
                        </telerik:RadDatePicker>
                        <label style="margin-left: 15px; font-weight: bold">đến ngày</label>
                        <telerik:RadDatePicker ID="rdtEndTime" runat="server" Width="140px">
                            <DateInput DateFormat="dd/MM/yyyy" runat="server" />
                        </telerik:RadDatePicker>
                    </div>
                </div>
                <div class="timkiem">
                    <input type="button" id="btnTim" value="Tìm" data-bind="click: btnSearch" />
                    <input type="button" id="btnXuatExcel" value="Xuất Excel" style="display: none;" data-bind="click: excelExport" />
                    <input type="button" id="bttExportUser" value="Danh sách SV đã khảo sát" style="display: none;" data-bind="click: excelExportUserList" />
                    <input type="button" id="bttTextAnswerExcel" value="Xuất Excel Câu trả lời" style="display: none" data-bind="click: excelExportTextAnswer" />
                    <input type="button" id="bttResultByEachUser" value="Xuất Excel cụ thể người dùng" style="display: none;" data-bind="click: excelExportResultByEachUser" />
                    <input type="button" runat="server" id="bttAnswerByUser" value="Xuất kết quả trả lời" style="display: none;" data-bind="click: excelExportAnswerByUser" />
                    <input type="button" runat="server" id="bttExportData" value="Xuất chi tiết" style="display: none;" data-bind="click: excelExportData" />
                </div>
            </div>
        </div>
        <div style="text-align: center; position: absolute; z-index: 9999; top: 500px; left: 600px; margin-top: 100px; display: none;" id="imgLoading">
            <img alt="loading" src='/FrontEnd/Images/loading.gif' />
        </div>
    </div>
    <div style="float: left; clear: both; margin-top: 1.2rem;" id="table-wrapper">
        <table id="table-result" class="ui celled table" style="width: 100%; clear: both;"></table>
    </div>
    <div id="modal-confirm-delete" class="ui tiny modal modal-type">
        <div class="header modal-header" id="header-confirm-delete">
        </div>
        <div class="scrolling content modal-content" id="content-confirm-delete">
        </div>
        <div class="actions modal-action">
            <div class="ui inverted approve red button" id="action-delete">
                <i class="trash alternate icon"></i>Xoá
            </div>
            <div class="ui inverted deny blue button" id="action-cancel">
                <i class="sign out alternate icon"></i>Huỷ
            </div>
        </div>
    </div>
</asp:Content>
