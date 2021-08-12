window.addEventListener('DOMContentLoaded', event => {
    // Simple-DataTables
    // https://github.com/fiduswriter/Simple-DataTables/wiki

    const datatablesSimple = document.getElementById('datatablesSimple');
    if (datatablesSimple) {
        new simpleDatatables.DataTable(datatablesSimple
        ,{
          "paging":   false,
          "info":     false,
          "searchable": false,
          "fixedHeight": true,
          "fixedColumns":true
        	}
        );
    }





});
