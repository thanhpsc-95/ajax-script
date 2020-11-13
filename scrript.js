function renderDataTable(tableName, dataSource, columnOptions, urlRequest, postData, item) {
    const PAGING_TYPE = {
        NUMBER_ONLY: 'numbers',
        PRE_NEXT_ONLY: 'simple',
        SIMPLE_NUMBER: 'simple_numbers',
        FULL: 'full',
        FULL_NUMBER: 'full_numbers',
        FIRST_LAST_NUMBER: 'first_last_numbers'
    };
    var columKeys = dataSource[0].length > 0 ? Object.keys(dataSource[0].filter(x => typeof x !== undefined).shift()) : [];
    var arrResult = columnOptions.length > 0 ? columnOptions : columKeys;
    var tableNameId = `#${tableName}`;
    if ($('.dataTables_wrapper').is(':visible')) {
        $('.dataTables_wrapper').hide();
    }
    return $(tableNameId).DataTable({
        dom: '<"row"<"col-sm-5"B><"col-sm-7 clearfix"<"float-left"f><"float-right"l>>>rt<"row"<"col-sm-6 font-italic"i><"col-sm-6"p>>',
        language: {
            "decimal": "",
            "emptyTable": "Không có dữ liệu",
            "info": "Đang hiện từ _START_ đến _END_ trong tổng _TOTAL_ dòng",
            "infoEmpty": "Đang hiện 0 đến 0 của 0 dòng",
            "infoFiltered": "(Đã lọc từ _MAX_ dòng)",
            "infoPostFix": "",
            "thousands": ".",
            "lengthMenu": "Hiện _MENU_ dòng",
            "loadingRecords": "Đang tải...",
            "processing": "Đang thực hiện...",
            "search": "Tìm kiếm:",
            "zeroRecords": "Không tìm thấy dữ liệu",
            "paginate": {
                "first": "Đầu",
                "last": "Cuối",
                "next": "Kế",
                "previous": "Trước"
            }
        },
        colReorder: true,
        pagingType: PAGING_TYPE.SIMPLE_NUMBER,
        buttons:
            [
                {
                    extend: 'copyHtml5',
                    text: '<i class="fa fa-copy"></i>',
                    titleAttr: 'Sao chép',
                    className: 'd-none',
                    exportOptions: {
                        columns: ':visible'
                    }
                },
                {
                    extend: 'excelHtml5',
                    text: '<i class="fa fa-file-excel-o"></i>',
                    titleAttr: 'Xuất excel 1',
                    title: item.Name.toString(),
                    exportOptions: {
                        columns: ':visible'
                    }
                },
                {
                    text: '<i class="fa fa-file-excel-o"></i>',
                    titleAttr: 'Xuất excel 2',
                    action: function () {
                        var notify = $.notify('Đang xuất file', {
                            allow_dismiss: false,
                            showProgressbar: true,
                            icon: 'fa fa-info-circle'
                        });
                        $.ajax({
                            url: urlRequest,
                            dataType: "arraybuffer",
                            data: postData,
                            success: function (response, status, xhr) {
                                // response here is an instance of an ArrayBuffer object
                                var disposition = xhr.getResponseHeader('Content-Disposition');
                                if (disposition && disposition.indexOf('attachment') !== -1) {
                                    var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
                                    var matches = filenameRegex.exec(disposition);
                                    if (matches != null && matches[1]) {
                                        filename = matches[1].replace(/['"]/g, '');
                                    }
                                }

                                var type = xhr.getResponseHeader('Content-Type');
                                var blob = new Blob([response], { type: type });

                                if (typeof window.navigator.msSaveBlob !== 'undefined') {
                                    // IE workaround for "HTML7007: One or more blob URLs were revoked by closing the blob for which they were created. These URLs will no longer resolve as the data backing the URL has been freed."
                                    window.navigator.msSaveBlob(blob, filename);
                                } else {
                                    var URL = window.URL || window.webkitURL;
                                    var downloadUrl = URL.createObjectURL(blob);
                                    var a = document.createElement("a");

                                    if (filename) {
                                        if (typeof a.download === 'undefined') {
                                            window.location.href = downloadUrl;
                                        } else {
                                            a.href = downloadUrl;
                                            a.download = filename;
                                            document.body.appendChild(a);
                                            a.click();
                                        }
                                    } else {
                                        window.location.href = downloadUrl;
                                    }
                                    setTimeout(function () {
                                        URL.revokeObjectURL(downloadUrl);
                                        document.body.removeChild(a);
                                        notify.update({
                                            'icon': 'fa fa-check', 'type': 'success', 'message': 'Đã xuất file ' + filename, 'progress': 25
                                        });
                                    }, 100);
                                }
                            },
                            beforeSend: function () {
                                notify;
                            }
                            ,
                            error: function (xhr, status) {
                                notify.update({
                                    'icon': 'fa fa-exclamation-triangle',
                                    'type': 'danger',
                                    'message': 'Lỗi xuất file',
                                    'progress': 100
                                });
                            }
                        });
                    }
                },
                {
                    extend: 'pdfHtml5',
                    text: '<i class="fa fa-file-pdf-o"></i>',
                    titleAttr: 'Xuất pdf',
                    title: item.Name.toString(),
                    exportOptions: {
                        columns: ':visible'
                    }
                },
                {
                    extend: 'print',
                    text: '<i class="fa fa-print"></i>',
                    titleAttr: 'In',
                    className: 'd-none',
                    title: item.Name.toString()
                },
                {
                    extend: 'colvis',
                    text: '<i class="fa fa-table"></i>',
                    titleAttr: 'Cấu hình hiển thị'
                }
            ],
        destroy: true,
        pageLength: 25,
        lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'Tất cả']],
        data: dataSource[0],
        columns: arrResult.map(item => {
            const container = {};
            container.data = item;
            container.title = item;
            container.className = item;
            return container;
        }),
        initComplete: function () {
            var isHidden = $(tableNameId).hasClass('d-none');
            if (isHidden) {
                $(tableNameId).removeClass('d-none');
                $(tableNameId).parent().slideDown();
            } else {
                $(tableNameId).addClass('d-none');
                $(tableNameId).parent().slideUp();
            }
        },
        rowCallback: function (row, data) {
            $(row).on('click', function () {
                $(this).toggleClass('selected');
                let selected = $(this).hasClass("selected");
                if (selected) {
                    console.log(data);
                    $.notify(JSON.stringify(data));
                }
            });
        }
    });
}
